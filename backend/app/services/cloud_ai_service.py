"""
I-Fridge — Cloud AI Fallback Service
=======================================
Automatic fallback chain: Ollama (local) → OpenAI/Gemini (cloud) → mock.

Usage:
  Set API keys in .env:
    OPENAI_API_KEY=sk-...
    GEMINI_API_KEY=AIza...

  The service auto-detects which provider is available
  and routes requests through the fallback chain.
"""

import httpx
import json
import logging
from typing import Optional, Dict, List, Any

from app.core.config import get_settings

logger = logging.getLogger("ifridge.cloud_ai")


class CloudAIService:
    """Fallback AI service using OpenAI or Google Gemini."""

    def __init__(self):
        settings = get_settings()
        self.openai_key: Optional[str] = getattr(settings, 'OPENAI_API_KEY', None)
        self.gemini_key: Optional[str] = getattr(settings, 'GEMINI_API_KEY', None)
        self._client = httpx.AsyncClient(timeout=60.0)

    @property
    def provider(self) -> Optional[str]:
        """Which cloud provider is configured."""
        if self.openai_key:
            return "openai"
        if self.gemini_key:
            return "gemini"
        return None

    @property
    def is_configured(self) -> bool:
        return self.provider is not None

    # ── OpenAI ───────────────────────────────────────────────────

    async def _openai_generate(
        self, prompt: str, system_prompt: Optional[str] = None,
        temperature: float = 0.7, max_tokens: int = 1024,
    ) -> str:
        messages = []
        if system_prompt:
            messages.append({"role": "system", "content": system_prompt})
        messages.append({"role": "user", "content": prompt})

        resp = await self._client.post(
            "https://api.openai.com/v1/chat/completions",
            headers={
                "Authorization": f"Bearer {self.openai_key}",
                "Content-Type": "application/json",
            },
            json={
                "model": "gpt-4o-mini",
                "messages": messages,
                "temperature": temperature,
                "max_tokens": max_tokens,
            },
        )
        resp.raise_for_status()
        data = resp.json()
        return data["choices"][0]["message"]["content"]

    # ── Gemini ───────────────────────────────────────────────────

    async def _gemini_generate(
        self, prompt: str, system_prompt: Optional[str] = None,
        temperature: float = 0.7, max_tokens: int = 1024,
    ) -> str:
        full_prompt = f"{system_prompt}\n\n{prompt}" if system_prompt else prompt

        resp = await self._client.post(
            f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key={self.gemini_key}",
            json={
                "contents": [{"parts": [{"text": full_prompt}]}],
                "generationConfig": {
                    "temperature": temperature,
                    "maxOutputTokens": max_tokens,
                },
            },
        )
        resp.raise_for_status()
        data = resp.json()
        return data["candidates"][0]["content"]["parts"][0]["text"]

    # ── Public API ───────────────────────────────────────────────

    async def generate_text(
        self, prompt: str, system_prompt: Optional[str] = None,
        temperature: float = 0.7, max_tokens: int = 1024,
    ) -> str:
        """Generate text using the configured cloud provider."""
        if self.openai_key:
            logger.info("[CloudAI] Using OpenAI gpt-4o-mini")
            return await self._openai_generate(prompt, system_prompt, temperature, max_tokens)
        elif self.gemini_key:
            logger.info("[CloudAI] Using Gemini 2.0 Flash")
            return await self._gemini_generate(prompt, system_prompt, temperature, max_tokens)
        else:
            raise RuntimeError("No cloud AI provider configured. Set OPENAI_API_KEY or GEMINI_API_KEY in .env")

    async def close(self):
        await self._client.aclose()


# ── Module-level singleton ───────────────────────────────────────
_cloud_instance: Optional[CloudAIService] = None

def get_cloud_ai_service() -> CloudAIService:
    global _cloud_instance
    if _cloud_instance is None:
        _cloud_instance = CloudAIService()
    return _cloud_instance

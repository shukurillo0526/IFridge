"""
I-Fridge — Expiry Prediction Unit Tests
==========================================
Tests smart expiry prediction logic with storage location,
packaging, and category factors.
"""

import pytest
from datetime import date, timedelta


class TestPredictExpiry:
    def test_meat_default_3_days(self):
        from app.services.expiry_prediction import predict_expiry

        result = predict_expiry("meat", purchase_date=date.today())
        assert result["shelf_life_days"] == 3
        expected = (date.today() + timedelta(days=3)).isoformat()
        assert result["expiry_date"] == expected

    def test_dairy_default_10_days(self):
        from app.services.expiry_prediction import predict_expiry

        result = predict_expiry("dairy")
        assert result["shelf_life_days"] == 10

    def test_freezer_extends_6x(self):
        from app.services.expiry_prediction import predict_expiry

        fridge = predict_expiry("meat", storage_location="fridge")
        freezer = predict_expiry("meat", storage_location="freezer")
        assert freezer["shelf_life_days"] == fridge["shelf_life_days"] * 6

    def test_pantry_halves_perishables(self):
        from app.services.expiry_prediction import predict_expiry

        fridge = predict_expiry("dairy", storage_location="fridge")
        pantry = predict_expiry("dairy", storage_location="pantry")
        assert pantry["shelf_life_days"] == fridge["shelf_life_days"] // 2

    def test_sealed_adds_50_percent(self):
        from app.services.expiry_prediction import predict_expiry

        opened = predict_expiry("vegetable", packaging="opened")
        sealed = predict_expiry("vegetable", packaging="sealed")
        assert sealed["shelf_life_days"] > opened["shelf_life_days"]

    def test_shelf_stable_ignores_storage(self):
        from app.services.expiry_prediction import predict_expiry

        fridge = predict_expiry("grain", storage_location="fridge")
        pantry = predict_expiry("grain", storage_location="pantry")
        assert fridge["shelf_life_days"] == pantry["shelf_life_days"]

    def test_canned_long_life(self):
        from app.services.expiry_prediction import predict_expiry

        result = predict_expiry("canned")
        assert result["shelf_life_days"] >= 365

    def test_unknown_category_defaults_14(self):
        from app.services.expiry_prediction import predict_expiry

        result = predict_expiry("mystery_food")
        assert result["shelf_life_days"] == 14
        assert result["confidence"] == "medium"

    def test_known_category_high_confidence(self):
        from app.services.expiry_prediction import predict_expiry

        result = predict_expiry("fruit")
        assert result["confidence"] == "high"

    def test_factors_list_populated(self):
        from app.services.expiry_prediction import predict_expiry

        result = predict_expiry("meat", storage_location="freezer", packaging="sealed")
        assert len(result["factors"]) >= 2
        assert any("freezer" in f for f in result["factors"])
        assert any("sealed" in f for f in result["factors"])

    def test_seafood_very_short(self):
        from app.services.expiry_prediction import predict_expiry

        result = predict_expiry("seafood")
        assert result["shelf_life_days"] == 2

    def test_custom_purchase_date(self):
        from app.services.expiry_prediction import predict_expiry

        yesterday = date.today() - timedelta(days=1)
        result = predict_expiry("fruit", purchase_date=yesterday)
        # Expiry should be 5 days from yesterday = 4 days from today
        expected = (yesterday + timedelta(days=5)).isoformat()
        assert result["expiry_date"] == expected

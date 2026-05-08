-- Fix #8: Create the consume_inventory_item RPC function
-- This function decrements an inventory item's quantity by the specified amount.
-- If the quantity reaches 0 or below, the item is automatically deleted.

CREATE OR REPLACE FUNCTION public.consume_inventory_item(
    p_inventory_id UUID,
    p_qty_to_consume NUMERIC DEFAULT 1.0
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
    current_qty NUMERIC;
BEGIN
    -- Get current quantity
    SELECT quantity INTO current_qty
    FROM inventory_items
    WHERE id = p_inventory_id;

    IF current_qty IS NULL THEN
        RAISE EXCEPTION 'Inventory item not found: %', p_inventory_id;
    END IF;

    IF current_qty <= p_qty_to_consume THEN
        -- Delete the item if quantity would reach 0 or below
        DELETE FROM inventory_items WHERE id = p_inventory_id;
    ELSE
        -- Decrement the quantity
        UPDATE inventory_items
        SET quantity = quantity - p_qty_to_consume,
            updated_at = NOW()
        WHERE id = p_inventory_id;
    END IF;
END;
$$;

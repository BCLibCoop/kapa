BEGIN;

CREATE TABLE barcodes_by_symbol (
    symbol  character varying(25),
    barcode character varying(100)
);

CREATE INDEX barcodes_by_symbol_symbol ON barcodes_by_symbol (symbol);
CREATE INDEX barcodes_by_symbol_barcode ON barcodes_by_symbol (barcode);

COMMIT;


INSERT INTO BANK (client_id, bank_name, aba_number, address, city, state, zip_code, phone_number)
SELECT 040, 'Waterfront Bank', '111222333', '1 Watertower Place', 'Chicago', 'IL', '60606', '3125550001' FROM dual
UNION ALL
SELECT 041, 'Willis Bank', '111222444', '2 Watertower Place', 'Chicago', 'IL', '60606', '3125550002' FROM dual;

COMMIT;
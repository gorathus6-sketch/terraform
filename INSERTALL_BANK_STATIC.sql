INSERT ALL
  INTO bank (client_id, bank_name, aba_number, address, city, state, zip_code, phone_number)
    VALUES (001, 'Bank 1', '123456789', '1 Main St', 'New York', 'NY', '10000', '2125550001')
  INTO bank (client_id, bank_name, aba_number, address, city, state, zip_code, phone_number)
    VALUES (002, 'Bank 2', '987654321', '10 Main St', 'New York', 'NY', '10000', '2125550010')
SELECT * FROM dual;

COMMIT;
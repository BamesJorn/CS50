-- Keep a log of any SQL queries you execute as you solve the mystery.

-- 1. As suggested, let's take a look inside the very first table
SELECT * FROM crime_scene_reports;

-- 2. Interviews with 3 wintesses are available
SELECT * FROM interviews WHERE day = 28;

-- 3. Look for the car in corr. table
SELECT * FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour < 12;

-- 4. List the transactions on ATM from Fifer Street
SELECT * FROM atm_transactions WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location LIKE '%Fifer Street%';

-- 5. Identify IDs of suspected accound holders
SELECT * FROM bank_accounts JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location LIKE '%Fifer Street%';

-- 6. Having IDs identify personal data
SELECT id, name, phone_number, passport_number, license_plate FROM people
WHERE id IN (SELECT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location LIKE '%Fifer Street%' AND transaction_type = 'withdraw');

-- 7. Detect coinciding license plates that exit on 28th of July
SELECT DISTINCT people.id, name, phone_number, passport_number, people.license_plate FROM people
JOIN courthouse_security_logs ON courthouse_security_logs.license_plate = people.license_plate
WHERE people.id IN (SELECT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location LIKE '%Fifer Street%' AND transaction_type = 'withdraw')
AND courthouse_security_logs.license_plate IN (SELECT courthouse_security_logs.license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour < 12);

-- 8. That a look at calls made on July 28 less than a minute long, detect the suspect's phone numbers
SELECT caller FROM phone_calls WHERE year = 2020 AND month = 7 AND day = 28 AND duration <= 60
AND caller IN (SELECT DISTINCT phone_number FROM people JOIN courthouse_security_logs ON courthouse_security_logs.license_plate = people.license_plate
WHERE people.id IN (SELECT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location LIKE '%Fifer Street%' AND transaction_type = 'withdraw')
AND courthouse_security_logs.license_plate IN (SELECT courthouse_security_logs.license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour < 12));

-- 9. Find out F airport id
SELECT airports.id FROM airports WHERE city = 'Fiftyville';

-- 10. Analyze flights data, get the earliest flight on July 29 from F airport
SELECT * FROM flights WHERE year = 2020 AND month = 7 AND day = 29 AND origin_airport_id IN (SELECT airports.id FROM airports WHERE city = 'Fiftyville') ORDER BY hour, minute LIMIT 1;

-- 11. Analyze passengers of the flight
SELECT * FROM passengers
WHERE flight_id = (SELECT flights.id FROM flights WHERE year = 2020 AND month = 7 AND day = 29 AND origin_airport_id IN (SELECT airports.id FROM airports WHERE city = 'Fiftyville') ORDER BY hour, minute LIMIT 1);

-- 12. Match the passport numbers from steps 11 and 8
SELECT passengers.passport_number FROM passengers WHERE flight_id = (SELECT flights.id FROM flights WHERE year = 2020 AND month = 7 AND day = 29 AND origin_airport_id IN (SELECT airports.id FROM airports WHERE city = 'Fiftyville') ORDER BY hour, minute LIMIT 1)
AND passengers.passport_number IN (SELECT people.passport_number FROM people WHERE people.phone_number IN
(SELECT caller FROM phone_calls WHERE year = 2020 AND month = 7 AND day = 28 AND duration <= 60
AND caller IN (SELECT DISTINCT phone_number FROM people JOIN courthouse_security_logs ON courthouse_security_logs.license_plate = people.license_plate
WHERE people.id IN (SELECT bank_accounts.person_id FROM bank_accounts JOIN atm_transactions ON atm_transactions.account_number = bank_accounts.account_number WHERE year = 2020 AND month = 7 AND day = 28 AND atm_location LIKE '%Fifer Street%' AND transaction_type = 'withdraw')
AND courthouse_security_logs.license_plate IN (SELECT courthouse_security_logs.license_plate FROM courthouse_security_logs WHERE year = 2020 AND month = 7 AND day = 28 AND hour < 11 AND minute < 26))));

-- 13. I forgot to implement 'within 10 minutes' condition in step 3, otherwise I would have had only 1 passport after step 12. So I added 'minute < 26' in step 12.
--     Now I have only one passport number. Technically I already know the name.
--     Let's find destination airport
SELECT city FROM airports WHERE airports.id = (SELECT destination_airport_id FROM flights WHERE year = 2020 AND month = 7 AND day = 29 AND origin_airport_id IN (SELECT airports.id FROM airports WHERE city = 'Fiftyville') ORDER BY hour, minute LIMIT 1);

-- 14. Accomplice is the reciver of the phone call
SELECT name FROM people WHERE phone_number = (SELECT receiver FROM phone_calls WHERE caller = '(367) 555-5533' AND year = 2020 AND month = 7 AND day = 28 AND duration < 60);

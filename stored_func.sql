CREATE OR REPLACE FUNCTION number_of_developed_progs(
     package_name varchar(128)
     )
    RETURNS int as $$
DECLARE
    result int := 0;
BEGIN
    EXECUTE format('SELECT count("Developer".id) FROM "Developer"
                 JOIN "Source code X Developer" "S c X D" ON "Developer".id = "S c X D".developer_id
                 JOIN "Source Code" "S C" ON "S C".id = "S c X D".source_id
                 WHERE developer_nm = ''%s''', package_name) INTO result;
    RETURN result;
end;
$$ LANGUAGE plpgsql;

SELECT number_of_developed_progs('Linus Torvalds');

-----------------

CREATE OR REPLACE FUNCTION mask_email(
    email text,
    offset_left int,
    offset_right int
)
    RETURNS text AS $$
DECLARE
    answer text:= '';
BEGIN
    answer = concat(answer, left(email, offset_left));

    FOR i in offset_left .. length(split_part($1, '@', 1)) - offset_right
    LOOP
    answer = concat(answer, '*');
    END LOOP;

    answer = concat(answer, right(split_part($1, '@', 1), offset_right));
    answer = concat(answer, '@');
    answer = concat(answer, split_part($1, '@', 2));
    return answer;
END
$$ LANGUAGE plpgsql;

SELECT mask_email('MishaPidor@mail.ru', 1, 2);

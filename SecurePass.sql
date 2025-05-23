PGDMP                         }         
   SecurePass    14.17    14.17                0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    25370 
   SecurePass    DATABASE     [   CREATE DATABASE "SecurePass" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en-US';
    DROP DATABASE "SecurePass";
                postgres    false                        3079    25371    pgcrypto 	   EXTENSION     <   CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;
    DROP EXTENSION pgcrypto;
                   false                       0    0    EXTENSION pgcrypto    COMMENT     <   COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';
                        false    2            �            1255    25424    decrypt_password(bytea)    FUNCTION     �   CREATE FUNCTION public.decrypt_password(encrypted_password bytea) RETURNS text
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
BEGIN
  RETURN convert_from(
    decrypt(encrypted_password, convert_to('NoAccess', 'utf8'), 'bf'),
    'utf8'
  );
END;
$$;
 A   DROP FUNCTION public.decrypt_password(encrypted_password bytea);
       public          postgres    false            �            1255    25418    generate_password(integer)    FUNCTION       CREATE FUNCTION public.generate_password(pass_length integer DEFAULT 12) RETURNS text
    LANGUAGE plpgsql
    AS $_$
DECLARE
    charSet TEXT := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*()_+-=[]{}|;:,.<>?';
    result TEXT := '';
    random_index INTEGER;
BEGIN
    FOR i IN 1 .. pass_length LOOP
        random_index := FLOOR(RANDOM() * LENGTH(charSet))::INTEGER + 1;
        result := result || SUBSTRING(charSet FROM random_index FOR 1);
    END LOOP;
    RETURN result;
END;
$_$;
 =   DROP FUNCTION public.generate_password(pass_length integer);
       public          postgres    false            �            1255    25419 *   store_secure_password(text, text, integer)    FUNCTION     �  CREATE FUNCTION public.store_secure_password(user_ident text, pass text, strength integer DEFAULT NULL::integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    encryption_key TEXT := 'replace_with_your_secret_key';  -- Set a strong secret key here!
BEGIN
    INSERT INTO secure_passwords (user_identifier, password, strength)
    VALUES (user_ident, pgp_sym_encrypt(pass, encryption_key), strength);
END;
$$;
 Z   DROP FUNCTION public.store_secure_password(user_ident text, pass text, strength integer);
       public          postgres    false            �            1259    25409    secure_passwords    TABLE     �   CREATE TABLE public.secure_passwords (
    id integer NOT NULL,
    user_identifier text,
    password bytea NOT NULL,
    strength integer,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
 $   DROP TABLE public.secure_passwords;
       public         heap    postgres    false            �            1259    25408    secure_passwords_id_seq    SEQUENCE     �   CREATE SEQUENCE public.secure_passwords_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public.secure_passwords_id_seq;
       public          postgres    false    211                       0    0    secure_passwords_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public.secure_passwords_id_seq OWNED BY public.secure_passwords.id;
          public          postgres    false    210            �           2604    25412    secure_passwords id    DEFAULT     z   ALTER TABLE ONLY public.secure_passwords ALTER COLUMN id SET DEFAULT nextval('public.secure_passwords_id_seq'::regclass);
 B   ALTER TABLE public.secure_passwords ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    211    211                      0    25409    secure_passwords 
   TABLE DATA           _   COPY public.secure_passwords (id, user_identifier, password, strength, created_at) FROM stdin;
    public          postgres    false    211   c                  0    0    secure_passwords_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.secure_passwords_id_seq', 19, true);
          public          postgres    false    210            �           2606    25417 &   secure_passwords secure_passwords_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public.secure_passwords
    ADD CONSTRAINT secure_passwords_pkey PRIMARY KEY (id);
 P   ALTER TABLE ONLY public.secure_passwords DROP CONSTRAINT secure_passwords_pkey;
       public            postgres    false    211               R   x����  �w;�@�B�e7�(����;w�/���q��.ZV�>ә���iC�2��@�7I���F���c���0�-     
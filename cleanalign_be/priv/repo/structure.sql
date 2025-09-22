--
-- PostgreSQL database dump
--

\restrict ffQZXyBUHtyCvNUY0dsasLnS8U168TcAcLL8QDCyZj5pv8bAFEpj0DEori3h3AM

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: ash_elixir_and(anycompatible, anycompatible); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ash_elixir_and("left" anycompatible, "right" anycompatible, OUT f1 anycompatible) RETURNS anycompatible
    LANGUAGE sql IMMUTABLE
    SET search_path TO ''
    AS $_$
  SELECT CASE
    WHEN $1 IS NOT NULL THEN $2
    ELSE $1
  END $_$;


--
-- Name: ash_elixir_and(boolean, anycompatible); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ash_elixir_and("left" boolean, "right" anycompatible, OUT f1 anycompatible) RETURNS anycompatible
    LANGUAGE sql IMMUTABLE
    SET search_path TO ''
    AS $_$
  SELECT CASE
    WHEN $1 IS TRUE THEN $2
    ELSE $1
  END $_$;


--
-- Name: ash_elixir_or(anycompatible, anycompatible); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ash_elixir_or("left" anycompatible, "right" anycompatible, OUT f1 anycompatible) RETURNS anycompatible
    LANGUAGE sql IMMUTABLE
    SET search_path TO ''
    AS $_$ SELECT COALESCE($1, $2) $_$;


--
-- Name: ash_elixir_or(boolean, anycompatible); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ash_elixir_or("left" boolean, "right" anycompatible, OUT f1 anycompatible) RETURNS anycompatible
    LANGUAGE sql IMMUTABLE
    SET search_path TO ''
    AS $_$ SELECT COALESCE(NULLIF($1, FALSE), $2) $_$;


--
-- Name: ash_raise_error(jsonb); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ash_raise_error(json_data jsonb) RETURNS boolean
    LANGUAGE plpgsql STABLE
    SET search_path TO ''
    AS $$
BEGIN
    -- Raise an error with the provided JSON data.
    -- The JSON object is converted to text for inclusion in the error message.
    RAISE EXCEPTION 'ash_error: %', json_data::text;
    RETURN NULL;
END;
$$;


--
-- Name: ash_raise_error(jsonb, anycompatible); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ash_raise_error(json_data jsonb, type_signal anycompatible) RETURNS anycompatible
    LANGUAGE plpgsql STABLE
    SET search_path TO ''
    AS $$
BEGIN
    -- Raise an error with the provided JSON data.
    -- The JSON object is converted to text for inclusion in the error message.
    RAISE EXCEPTION 'ash_error: %', json_data::text;
    RETURN NULL;
END;
$$;


--
-- Name: ash_trim_whitespace(text[]); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.ash_trim_whitespace(arr text[]) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE
    SET search_path TO ''
    AS $$
DECLARE
    start_index INT = 1;
    end_index INT = array_length(arr, 1);
BEGIN
    WHILE start_index <= end_index AND arr[start_index] = '' LOOP
        start_index := start_index + 1;
    END LOOP;

    WHILE end_index >= start_index AND arr[end_index] = '' LOOP
        end_index := end_index - 1;
    END LOOP;

    IF start_index > end_index THEN
        RETURN ARRAY[]::text[];
    ELSE
        RETURN arr[start_index : end_index];
    END IF;
END; $$;


--
-- Name: timestamp_from_uuid_v7(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.timestamp_from_uuid_v7(_uuid uuid) RETURNS timestamp without time zone
    LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
    SET search_path TO ''
    AS $$
  SELECT to_timestamp(('x0000' || substr(_uuid::TEXT, 1, 8) || substr(_uuid::TEXT, 10, 4))::BIT(64)::BIGINT::NUMERIC / 1000);
$$;


--
-- Name: uuid_generate_v7(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.uuid_generate_v7() RETURNS uuid
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  timestamp    TIMESTAMPTZ;
  microseconds INT;
BEGIN
  timestamp    = clock_timestamp();
  microseconds = (cast(extract(microseconds FROM timestamp)::INT - (floor(extract(milliseconds FROM timestamp))::INT * 1000) AS DOUBLE PRECISION) * 4.096)::INT;

  RETURN encode(
    set_byte(
      set_byte(
        overlay(uuid_send(gen_random_uuid()) placing substring(int8send(floor(extract(epoch FROM timestamp) * 1000)::BIGINT) FROM 3) FROM 1 FOR 6
      ),
      6, (b'0111' || (microseconds >> 8)::bit(4))::bit(8)::int
    ),
    7, microseconds::bit(8)::int
  ),
  'hex')::UUID;
END
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL
);


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    role_id uuid NOT NULL
);


--
-- Name: user_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    token text NOT NULL,
    type text NOT NULL,
    expires_at timestamp(0) without time zone NOT NULL,
    user_id uuid NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email public.citext NOT NULL,
    hashed_password text NOT NULL
);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id, user_id, role_id);


--
-- Name: user_tokens user_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: roles_unique_name_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX roles_unique_name_index ON public.roles USING btree (name);


--
-- Name: user_roles_unique_user_role_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX user_roles_unique_user_role_index ON public.user_roles USING btree (user_id, role_id);


--
-- Name: users_unique_email_index; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_unique_email_index ON public.users USING btree (email);


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: user_tokens user_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_tokens
    ADD CONSTRAINT user_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict ffQZXyBUHtyCvNUY0dsasLnS8U168TcAcLL8QDCyZj5pv8bAFEpj0DEori3h3AM

INSERT INTO public."schema_migrations" (version) VALUES (20250922010841);
INSERT INTO public."schema_migrations" (version) VALUES (20250922010843);

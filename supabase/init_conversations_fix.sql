CREATE TABLE public.conversations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  personality text DEFAULT 'master'::text,
  title text DEFAULT '新对话'::text,
  messages jsonb DEFAULT '[]'::jsonb,
  created_at timestamp with time zone DEFAULT now(),
  updated_at timestamp with time zone DEFAULT now(),
  source_type text DEFAULT 'chat'::text,
  source_data jsonb,
  CONSTRAINT conversations_pkey PRIMARY KEY (id),
  CONSTRAINT conversations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id)
);

CREATE TABLE public.hepan_charts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  type text NOT NULL CHECK (type = ANY (ARRAY['love'::text, 'business'::text, 'family'::text])),
  person1_name text NOT NULL,
  person1_birth jsonb NOT NULL,
  person2_name text NOT NULL,
  person2_birth jsonb NOT NULL,
  compatibility_score integer,
  created_at timestamp with time zone DEFAULT now(),
  conversation_id uuid,
  result_data jsonb,
  CONSTRAINT hepan_charts_pkey PRIMARY KEY (id),
  CONSTRAINT hepan_charts_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT hepan_charts_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id)
);

CREATE TABLE public.tarot_readings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  spread_id text NOT NULL,
  question text,
  cards jsonb NOT NULL,
  created_at timestamp with time zone DEFAULT now(),
  conversation_id uuid,
  metadata jsonb NOT NULL DEFAULT '{}'::jsonb,
  CONSTRAINT tarot_readings_pkey PRIMARY KEY (id),
  CONSTRAINT tarot_readings_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT tarot_readings_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id)
);

CREATE TABLE public.liuyao_divinations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  question text NOT NULL,
  hexagram_code text NOT NULL,
  changed_hexagram_code text,
  changed_lines jsonb,
  created_at timestamp with time zone DEFAULT now(),
  conversation_id uuid,
  CONSTRAINT liuyao_divinations_pkey PRIMARY KEY (id),
  CONSTRAINT liuyao_divinations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT liuyao_divinations_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id)
);

CREATE TABLE public.qimen_charts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  question text,
  chart_time timestamp with time zone NOT NULL,
  dun_type text NOT NULL CHECK (dun_type = ANY (ARRAY['yang'::text, 'yin'::text])),
  ju_number integer NOT NULL CHECK (ju_number >= 1 AND ju_number <= 9),
  pan_type text NOT NULL DEFAULT 'zhuan'::text CHECK (pan_type = 'zhuan'::text),
  ju_method text NOT NULL DEFAULT 'chaibu'::text CHECK (ju_method = ANY (ARRAY['chaibu'::text, 'maoshan'::text])),
  conversation_id uuid,
  created_at timestamp with time zone DEFAULT now(),
  year integer NOT NULL,
  month integer NOT NULL CHECK (month >= 1 AND month <= 12),
  day integer NOT NULL CHECK (day >= 1 AND day <= 31),
  hour integer NOT NULL CHECK (hour >= 0 AND hour <= 23),
  minute integer NOT NULL CHECK (minute >= 0 AND minute <= 59),
  timezone text NOT NULL DEFAULT 'Asia/Shanghai'::text,
  zhi_fu_ji_gong text NOT NULL DEFAULT 'ji_liuyi'::text CHECK (zhi_fu_ji_gong = ANY (ARRAY['ji_liuyi'::text, 'ji_wugong'::text])),
  CONSTRAINT qimen_charts_pkey PRIMARY KEY (id),
  CONSTRAINT qimen_charts_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT qimen_charts_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id)
);

CREATE TABLE public.daliuren_divinations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid,
  question text,
  solar_date text NOT NULL,
  day_ganzhi text NOT NULL,
  hour_ganzhi text NOT NULL,
  yue_jiang text NOT NULL,
  result_data jsonb NOT NULL,
  settings jsonb,
  conversation_id uuid,
  created_at timestamp with time zone DEFAULT now(),
  CONSTRAINT daliuren_divinations_pkey PRIMARY KEY (id),
  CONSTRAINT daliuren_divinations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT daliuren_divinations_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id)
);

CREATE TABLE public.meihua_divinations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  question text NOT NULL CHECK (length(btrim(question)) > 0),
  method text NOT NULL CHECK (method = ANY (ARRAY['time'::text, 'text_split'::text, 'number_pair'::text, 'number_triplet'::text])),
  cast_datetime timestamp without time zone NOT NULL,
  main_hexagram text NOT NULL,
  changed_hexagram text,
  input_data jsonb NOT NULL,
  result_data jsonb NOT NULL,
  conversation_id uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT meihua_divinations_pkey PRIMARY KEY (id),
  CONSTRAINT meihua_divinations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE,
  CONSTRAINT meihua_divinations_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE SET NULL
);

CREATE TABLE public.xiaoliuren_divinations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  question text,
  solar_datetime timestamp without time zone NOT NULL,
  lunar_month smallint NOT NULL CHECK (lunar_month >= 1 AND lunar_month <= 12),
  lunar_day smallint NOT NULL CHECK (lunar_day >= 1 AND lunar_day <= 30),
  is_leap_month boolean NOT NULL DEFAULT false,
  shichen text NOT NULL,
  final_status text NOT NULL CHECK (final_status = ANY (ARRAY['大安'::text, '留连'::text, '速喜'::text, '赤口'::text, '小吉'::text, '空亡'::text])),
  input_data jsonb NOT NULL,
  result_data jsonb NOT NULL,
  conversation_id uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT xiaoliuren_divinations_pkey PRIMARY KEY (id),
  CONSTRAINT xiaoliuren_divinations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE,
  CONSTRAINT xiaoliuren_divinations_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON DELETE SET NULL
);

CREATE TABLE public.mbti_readings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  mbti_type text NOT NULL,
  scores jsonb,
  percentages jsonb,
  created_at timestamp with time zone DEFAULT now(),
  conversation_id uuid,
  CONSTRAINT mbti_readings_pkey PRIMARY KEY (id),
  CONSTRAINT mbti_readings_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT mbti_readings_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id)
);

CREATE TABLE public.face_readings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  analysis_type text DEFAULT 'full'::text,
  created_at timestamp with time zone DEFAULT now(),
  conversation_id uuid,
  CONSTRAINT face_readings_pkey PRIMARY KEY (id),
  CONSTRAINT face_readings_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT face_readings_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id)
);

CREATE TABLE public.palm_readings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL,
  analysis_type text DEFAULT 'full'::text,
  hand_type text DEFAULT 'left'::text CHECK (hand_type = ANY (ARRAY['left'::text, 'right'::text, 'both'::text])),
  created_at timestamp with time zone DEFAULT now(),
  conversation_id uuid,
  CONSTRAINT palm_readings_pkey PRIMARY KEY (id),
  CONSTRAINT palm_readings_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id),
  CONSTRAINT palm_readings_conversation_id_fkey FOREIGN KEY (conversation_id) REFERENCES public.conversations(id)
);

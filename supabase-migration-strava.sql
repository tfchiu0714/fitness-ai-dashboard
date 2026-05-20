ALTER TABLE api_settings ADD COLUMN IF NOT EXISTS strava_access_token TEXT DEFAULT '';
ALTER TABLE api_settings ADD COLUMN IF NOT EXISTS strava_refresh_token TEXT DEFAULT '';
ALTER TABLE api_settings ADD COLUMN IF NOT EXISTS strava_expires_at TIMESTAMPTZ;
ALTER TABLE api_settings ADD COLUMN IF NOT EXISTS strava_athlete_id TEXT DEFAULT '';
ALTER TABLE api_settings ADD COLUMN IF NOT EXISTS strava_athlete_name TEXT DEFAULT '';

CREATE TABLE IF NOT EXISTS strava_activities (
  id BIGINT PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  data JSONB NOT NULL,
  start_date TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_strava_user_date ON strava_activities(user_id, start_date DESC);

ALTER TABLE strava_activities ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'strava_act_select') THEN
    CREATE POLICY "strava_act_select" ON strava_activities FOR SELECT USING (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'strava_act_insert') THEN
    CREATE POLICY "strava_act_insert" ON strava_activities FOR INSERT WITH CHECK (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'strava_act_update') THEN
    CREATE POLICY "strava_act_update" ON strava_activities FOR UPDATE USING (auth.uid() = user_id);
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_policies WHERE policyname = 'strava_act_delete') THEN
    CREATE POLICY "strava_act_delete" ON strava_activities FOR DELETE USING (auth.uid() = user_id);
  END IF;
END $$;

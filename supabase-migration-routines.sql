CREATE TABLE IF NOT EXISTS routine_trainings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  type TEXT DEFAULT 'Other',
  day_of_week INT NOT NULL,
  time_str TEXT DEFAULT '',
  duration TEXT DEFAULT '',
  dist TEXT DEFAULT '',
  zone TEXT DEFAULT 'Z2',
  note TEXT DEFAULT '',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE routine_trainings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "routines_select" ON routine_trainings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "routines_insert" ON routine_trainings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "routines_update" ON routine_trainings FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "routines_delete" ON routine_trainings FOR DELETE USING (auth.uid() = user_id);

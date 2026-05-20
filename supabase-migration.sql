CREATE TABLE IF NOT EXISTS races (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  date DATE NOT NULL,
  type TEXT NOT NULL DEFAULT 'B',
  dist TEXT DEFAULT '',
  sort_order INT DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS ai_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  plan_data JSONB NOT NULL,
  commentary TEXT DEFAULT '',
  saved_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE TABLE IF NOT EXISTS ai_coach (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  commentary TEXT DEFAULT '',
  saved_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

CREATE TABLE IF NOT EXISTS api_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  api_key TEXT DEFAULT '',
  api_url TEXT DEFAULT 'https://api.deepseek.com/chat/completions',
  api_model TEXT DEFAULT 'deepseek-chat',
  saved_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id)
);

-- ============================================================
-- Step 2: Enable Row Level Security
-- ============================================================
ALTER TABLE races ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_coach ENABLE ROW LEVEL SECURITY;
ALTER TABLE api_settings ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- Step 3: Create RLS policies (users can ONLY see their own data)
-- ============================================================

-- Races
CREATE POLICY "races_select" ON races FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "races_insert" ON races FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "races_update" ON races FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "races_delete" ON races FOR DELETE USING (auth.uid() = user_id);

-- AI Plans
CREATE POLICY "ai_plans_select" ON ai_plans FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "ai_plans_insert" ON ai_plans FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "ai_plans_update" ON ai_plans FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "ai_plans_delete" ON ai_plans FOR DELETE USING (auth.uid() = user_id);

-- AI Coach
CREATE POLICY "ai_coach_select" ON ai_coach FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "ai_coach_insert" ON ai_coach FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "ai_coach_update" ON ai_coach FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "ai_coach_delete" ON ai_coach FOR DELETE USING (auth.uid() = user_id);

-- API Settings
CREATE POLICY "api_settings_select" ON api_settings FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "api_settings_insert" ON api_settings FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "api_settings_update" ON api_settings FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "api_settings_delete" ON api_settings FOR DELETE USING (auth.uid() = user_id);

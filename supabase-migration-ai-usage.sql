-- Migration: AI usage tracking table for rate limiting
CREATE TABLE IF NOT EXISTS ai_usage (
  id BIGSERIAL PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  usage_date DATE NOT NULL DEFAULT CURRENT_DATE,
  call_type TEXT NOT NULL DEFAULT 'plan', -- 'plan' or 'coach'
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ai_usage_user_date ON ai_usage(user_id, usage_date);

-- Enable RLS
ALTER TABLE ai_usage ENABLE ROW LEVEL SECURITY;

-- Allow users to read only their own usage
CREATE POLICY "Users can read own usage" ON ai_usage
  FOR SELECT USING (auth.uid() = user_id);

-- Allow users to insert only their own usage (user_id must match)
CREATE POLICY "Users can insert own usage" ON ai_usage
  FOR INSERT WITH CHECK (auth.uid() = user_id);

-- Allow users to delete only their own usage (for cleanup if needed)
CREATE POLICY "Users can delete own usage" ON ai_usage
  FOR DELETE USING (auth.uid() = user_id);

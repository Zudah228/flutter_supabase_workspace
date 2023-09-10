class SupabaseSettings {
  final String url;
  final String apiKey;

  const SupabaseSettings({required this.url, required this.apiKey});
}

const supabaseSettings = SupabaseSettings(
  url: String.fromEnvironment('SUPABASE_URL'),
  apiKey: String.fromEnvironment('SUPABASE_API_KEY'),
);

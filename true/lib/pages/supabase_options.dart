class SupabaseOptions {
  final String url;
  final String anonKey;

  SupabaseOptions({
    required this.url,
    required this.anonKey,
  });
}

final SupabaseOptions supabaseOptions = SupabaseOptions(
  url: 'https://ucjhemnyoxpndqrjnrpz.supabase.co',
  anonKey:
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InVjamhlbW55b3hwbmRxcmpucnB6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjAwNjgzOTIsImV4cCI6MjAzNTY0NDM5Mn0.iYAuhJBNm5EydouSSa3WllQtQiAep2NioIQomWZyqMc',
);

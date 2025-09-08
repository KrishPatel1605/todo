import 'package:supabase_flutter/supabase_flutter.dart';

// TODO: Fill these with your project's details
const String SUPABASE_URL = 'https://ceteazchycpaifxpxnjz.supabase.co';
const String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNldGVhemNoeWNwYWlmeHB4bmp6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcyNjQwNDUsImV4cCI6MjA3Mjg0MDA0NX0.MBiFxod5AEAveCt5KRBdaPjQGULwpDfep3d075A3nBU';

final supabase = Supabase.instance.client;

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
}

import 'package:flutter/material.dart';

import '../widgets/announcements_block.dart';
import '../widgets/current_date_time.dart';
import '../widgets/page_header.dart';
import '../widgets/quick_action.dart';
import '../widgets/today_schedule.dart';
import '../services/link_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          //верхня панель
          const PageHeader(title: 'Головна'),

          const SizedBox(height: 28),

          //дата
          const CurrentDateTime(),

          const SizedBox(height: 30),

          const Text(
            'СЬОГОДНІ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          const TodaySchedule(),
          const SizedBox(height: 28),
          // Швидкі дії
          Row(
            children: [
              Expanded(
                child: QuickAction(
                  icon: Icons.school_outlined,
                  text: 'Moodle',
                  onTap: () {
                    LinkService.open('https://dls.viti.edu.ua/login/index.php');
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: QuickAction(
                  icon: Icons.menu_book_outlined,
                  text: 'Щоденник',
                  onTap: () {
                    LinkService.open(
                      'https://mitit.cloudflareaccess.com/cdn-cgi/access/login/gradebook.viti.edu.ua?kid=f4029a01a58a4e99da60ba138b23e4e14dd4907650d5d01f936ae2c22783c354&meta=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjA1ZDgxNDE5MTkxNjU1YTJmMzlhZGM0ZTZhNzFjMmE0YzcwMmIyOGFjZTM3MmI1ZGYwNzZkYWRkYjEyYWU0ZTQifQ.eyJ0eXBlIjoibWV0YSIsImF1ZCI6ImY0MDI5YTAxYTU4YTRlOTlkYTYwYmExMzhiMjNlNGUxNGRkNDkwNzY1MGQ1ZDAxZjkzNmFlMmMyMjc4M2MzNTQiLCJob3N0bmFtZSI6ImdyYWRlYm9vay52aXRpLmVkdS51YSIsInJlZGlyZWN0X3VybCI6Ii9yYXRpbmdzIiwic2VydmljZV90b2tlbl9zdGF0dXMiOmZhbHNlLCJpc193YXJwIjpmYWxzZSwiaXNfZ2F0ZXdheSI6ZmFsc2UsImV4cCI6MTc4ODUyMTAzNCwibmJmIjoxNzg4NTIwNzM0LCJpYXQiOjE3ODg1MjA3MzQsImF1dGhfc3RhdHVzIjoiTk9ORSIsIm10bHNfYXV0aCI6eyJjZXJ0X2lzc3Vlcl9kbiI6IiIsImNlcnRfc2VyaWFsIjoiIiwiY2VydF9pc3N1ZXJfc2tpIjoiIiwiY2VydF9wcmVzZW50ZWQiOmZhbHNlLCJjb21tb25fbmFtZSI6IiIsImF1dGhfc3RhdHVzIjoiTk9ORSJ9LCJyZWFsX2NvdW50cnkiOiJVQSIsImFwcF9zZXNzaW9uX2hhc2giOiJiNThiNjU5MDc0MjQyNWU1YzQ4Y2MzZDFkZjFiNGE1ODFlYWY0NTJlYjUxNjI2MzgzMzE2NzQxYzMxYzA3MTE2In0.UcsSwSdoIOKmMgwOJZn1U-9jsENvjpcyxUA4llDIUfQVwyJNXseGQLfvMMNyHOy9mzXdgHWYdwOA0GXhKhuxZb-HVR8Szne9_UaRzGdJRupjRIj0rBfZ-8QuSiNphhCTEqZ7x_Lt93tkodrBmEMNOKYfR2VcEOgn9GRx0sSy2XwqU9ncOYun8ug3rNCBxJOr6IPNT6jOT4M5n6CgXmfAHYHxSVtIMEjEXFfpK_UTQYbEmSVKdkZlPpVr27S9l44GEAFAG3tiOWll6sAKPV88K7LGYaLU8-7et3T48hBhr8B-7OL1ARepsvkm-2p5BKjKp7TvZUf0Ic0oJ0wExe3EQQ&redirect_url=%2Fratings',
                    );
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          Text(
            'СПОВІЩЕННЯ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 12),

          const AnnouncementsBlock(),
        ],
      ),
    );
  }
}

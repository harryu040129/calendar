# Flutter Calendar & Task UI
Flutter로 제작한 일정 관리 UI 프로토타입입니다. 홈의 작업 카드와 캘린더 화면 이동, 주간·월간 표시 전환, 메모리 내 작업 추가·수정·삭제를 연습했습니다.

## 구현 범위
- 홈의 예시 작업 카드와 진행률 표시
- 캘린더 화면 이동, 날짜 선택, 주간·월간 표시 전환
- 작업 제목과 시간의 추가·수정·삭제
- Flutter Material/Cupertino 위젯과 `intl` 날짜 포맷

작업 목록은 메모리에 저장되어 화면을 다시 만들거나 앱을 재시작하면 초기화됩니다. 날짜별로 독립 저장되는 일정 데이터베이스는 구현되어 있지 않습니다. 검색·필터와 하단 메뉴 일부는 UI만 구성되어 있습니다.

## 파일 안내
| 파일 | 역할 |
| --- | --- |
| [lib/main.dart](lib/main.dart) | 앱 진입점, 홈 화면, 작업 카드 |
| [lib/calendar_screen.dart](lib/calendar_screen.dart) | 캘린더와 작업 편집 UI |
| [pubspec.yaml](pubspec.yaml) | Dart SDK 제약과 Flutter 의존성 |
| [pubspec.lock](pubspec.lock) | 기존 패키지 잠금 파일 |

## 실행 준비
현재 저장소에는 `android/`, `ios/`, `web/` 등의 플랫폼 프로젝트가 없습니다. Dart `^3.5.1`을 만족하는 Flutter SDK에서 플랫폼 파일을 생성해야 합니다.

저장소 루트의 깨끗한 작업 사본에서:
```sh
flutter create --project-name test11 --platforms=android,ios,web .
flutter pub get
flutter run
```

생성 후 `git diff`로 변경 내용을 확인하세요. 기존 `lib/` 코드와 `pubspec.yaml`의 앱 의존성이 유지되는지 확인하고, 생성된 기본 테스트가 기존 앱과 다르면 조정해야 합니다. iOS 실행에는 macOS와 Xcode가 필요합니다.

## 현재 한계
월간 화면은 날짜를 순차 배치한 단순 UI이며, 정확한 요일 오프셋·이전/다음 달 탐색은 보완 대상입니다. 홈의 날짜·작업 수·진행률에도 예시 값이 사용됩니다.

이번 정리에서는 소스를 확인해 문서를 작성했으며, Flutter 빌드나 기기 실행은 수행하지 않았습니다.

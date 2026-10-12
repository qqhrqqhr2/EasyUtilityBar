# GitHub → CurseForge 자동 배포 설정

1. CurseForge에서 EasyUtilityBar WoW 애드온 프로젝트를 만들고 프로젝트 ID를 확인합니다.
2. GitHub 저장소 Settings → Secrets and variables → Actions → New repository secret에서 `CF_API_KEY`를 추가합니다.
3. 같은 곳에 `CF_PROJECT_ID`를 추가합니다.
4. 소스 파일은 저장소 최상위에 `EasyUtilityBar.toc`, `Core.lua`, `Locales/`, `Media/`로 업로드합니다.
5. `v0.5.4` 같은 태그를 푸시하면 Actions가 GitHub Release와 CurseForge 배포를 실행합니다.
6. CurseForge 프로젝트 승인 여부와 GitHub Actions 실행 로그를 확인합니다.

주의: CurseForge API 키는 저장소 파일에 절대 입력하지 마세요.

# GitHub → CurseForge 자동 배포 설정

- GitHub 저장소: https://github.com/qqhrqqhr2/EasyUtilityBar
- CurseForge Project ID: 1741884
- 배포 파일명 형식: EasyUtilityBar-버전-forever.zip (파일명 규칙은 packager 설정에서 별도 검증 필요)

1. GitHub 저장소 Settings → Secrets and variables → Actions → New repository secret에서 `CF_API_KEY`를 추가합니다.
2. CurseForge Project ID `1741884`는 릴리즈 워크플로에 고정되어 있어 별도 Secret이 필요하지 않습니다.
3. 애드온 소스 파일 `EasyUtilityBar.toc`, `Core.lua`, `Locales/` 등을 저장소 최상위에 업로드합니다.
4. `v0.5.5` 같은 Git 태그를 푸시하면 GitHub Actions가 GitHub Release와 CurseForge 패키징을 시도합니다.
5. CurseForge 승인 상태와 GitHub Actions 실행 결과를 확인합니다.

주의: API 키는 저장소 파일에 직접 기록하지 마세요. GitHub 연결에서는 Secret의 이름/등록 상태를 조회할 수 없으므로 Actions 실행 로그에서 확인해야 합니다.

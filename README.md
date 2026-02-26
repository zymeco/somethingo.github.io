# 초도제품 검사 프로토타입 실행 방법

이번 프로젝트는 **정적 웹 페이지(`index.html`)** 이라 설치 없이 브라우저로 실행할 수 있습니다.
다만 `file://` 로 더블클릭 실행보다 **로컬 서버 실행**을 권장합니다.

---

## 1) Windows (PowerShell)에서 실행

### 1-1. 먼저 폴더 위치 확인
`/workspace/somethingo.github.io` 는 이 개발 컨테이너 경로라서, Windows에서는 존재하지 않습니다.
PowerShell에서는 실제 PC 경로로 이동해야 합니다.

예시:
```powershell
cd C:\Users\ZYMECO\Downloads\somethingo.github.io
```

> 현재 `C:\Users\ZYMECO\Downloads` 에 계시므로, 먼저 `somethingo.github.io` 폴더를 해당 위치에 내려받아(또는 압축 해제) 두셔야 합니다.

### 1-2. Python으로 실행 (가장 쉬움)
Windows에서는 `python3` 대신 `py`가 더 잘 동작하는 경우가 많습니다.

```powershell
py -m http.server 4173
```

브라우저에서 접속:
- `http://localhost:4173`

정상이라면 터미널에 아래와 비슷하게 나옵니다:
- `Serving HTTP on 0.0.0.0 port 4173 ...`

### 1-3. 포트 충돌 시
```powershell
py -m http.server 5173
```
접속: `http://localhost:5173`

---

## 2) macOS / Linux 실행
```bash
cd /path/to/somethingo.github.io
python3 -m http.server 4173
```
접속: `http://localhost:4173`

---

## 3) Node 방식 실행(선택)
Node가 설치된 경우만 사용하세요.

```bash
npm start
```

- 기본 포트: `4173`
- 포트 변경: `PORT=5173 npm start`

### Windows에서 `npm : CommandNotFoundException` 발생 시
이는 Node.js가 설치되지 않았거나 PATH에 등록되지 않은 상태입니다.
- Node 없이도 **Python 방식으로 바로 실행 가능**합니다 (`py -m http.server 4173`).

---

## 4) 실행 확인 체크
- 페이지 상단 제목이 `초도제품 검사 · 스펙 비교 · 수정방향 제안`으로 보이면 정상.
- `샘플 데이터` 클릭 후 `통합 분석 실행` 시 KPI/추천 문구가 표시되면 정상.

---

## 5) 자주 발생하는 문제
1. **경로 오류**
   - `/workspace/...` 는 Windows 경로가 아닙니다.
   - `C:\Users\...` 형태의 실제 폴더로 이동하세요.

2. **브라우저 캐시로 예전 화면 표시**
   - 강력 새로고침: `Ctrl+Shift+R` (Mac: `Cmd+Shift+R`)

3. **저장/불러오기 미동작**
   - 시크릿 모드/회사 보안 정책에서 LocalStorage가 막힌 경우가 있으니 일반 창에서 실행하세요.

4. **CSV/엑셀 업로드 미반영**
   - 성적서 파일은 `.csv`, `.xlsx`, `.xls`를 지원합니다.
   - 권장 헤더: `항목명, 기준값, 하한, 상한, 실측값, ctq`
   - 동의어도 자동 인식합니다(예: `측정항목`, `target`, `lsl/usl`, `actual`).
   - 자동 인식이 틀리면 화면의 "컬럼 매핑"에서 직접 컬럼을 지정 후 반영할 수 있습니다.

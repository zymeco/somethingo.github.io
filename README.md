# 초도제품 검사 프로토타입 실행 방법

실행이 안 될 때 가장 먼저 **`index.html`을 더블클릭으로 열지 말고**, 로컬 서버로 열어주세요.

## 방법 1) Python으로 실행 (권장)
```bash
cd /workspace/somethingo.github.io
python3 -m http.server 4173
```
브라우저에서 `http://localhost:4173` 접속.

## 방법 2) Node로 실행
```bash
cd /workspace/somethingo.github.io
npm start
```
브라우저에서 `http://localhost:4173` 접속.

## 실행 확인 체크
- 페이지 상단 제목이 `초도제품 검사 · 스펙 비교 · 수정방향 제안` 으로 보이면 정상.
- `샘플 데이터` 버튼 클릭 후 `통합 분석 실행` 시 KPI와 추천 문구가 표시되면 정상.

## 자주 발생하는 문제
1. **포트 충돌(4173 이미 사용 중)**
   - 에러가 나면 다른 포트로 실행:
   ```bash
   python3 -m http.server 5173
   ```
   또는
   ```bash
   PORT=5173 npm start
   ```

2. **브라우저 캐시로 예전 페이지가 보임**
   - 강력 새로고침: `Ctrl+Shift+R` (Mac: `Cmd+Shift+R`).

3. **저장/불러오기 동작 안 함**
   - 시크릿 모드/보안 정책에서 LocalStorage가 막힌 경우가 있어 일반 창에서 접속하세요.

4. **CSV 업로드가 반영되지 않음**
   - 성적서 CSV 컬럼 순서를 아래와 같이 맞추세요:
   - `항목명,target,lower,upper,measured,ctq`

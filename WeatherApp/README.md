# Weather App
## (OpenWeather API)

### 라이브러리

이름|이유|버젼
:-:|:-:|:-:
SnapKit|UI Layout|5.0.1
Alamofire|API 통신|5.5.0
Kingfisher|웹 서버 이미지를 쉽게 적용|7.1.2

### Framework
- UIKit

### 기능
- 날씨 검색
    - UITextField
    - UITextFieldDelegate
    - 빈칸 있으면 제거 후 검색
    - 빈 화면 탭하면 키보드 내리기
    - 키보드 올라오거나 내려갈때 스크롤이 자연스럽게 되게 하기
- 날씨 정보 받아오기
    - Weather Model 만들기
    - FetchWeatherData 구조체 안의 `fetchData` 메소드 구현
    - 성공시 화면에 받은 날씨 정보 보이기
    - 실패시 UIAlertController로 에러 표시하기

### 결과
<p align="center"><img src="/resultImage.gif"></p>

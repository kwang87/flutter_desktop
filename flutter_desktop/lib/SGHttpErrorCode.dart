// ignore_for_file: file_names

const int successWeb = 0; //>통신성공

enum SGHttpErrorCode {
  successWeb, // OK
  failedResult, // 500 서버오류
  failedParam, // TIMESTAMP, HMAC 파라미터가 없는 잘못된 요청
  failedClientId, // CLIENT ID 가 유효하지 않음 (clientInstall 호출을 제외)
  failedTimestamp, // 시간 값이 서버와 1분이상 차이나는 경우 (예외 : "/getTempApiKey", /clientLogin, /clientInstall, /clientUninstall, loginWebOtp.sgn, requestLoginAddAuthNum)
  failedAPIKey, // API KEY 가 존재하지 않는 경우
  failedHMAC, // Hmac 조립 에러
  failedAuth, // 인증이 필요한 URL에 인증없이 접근했을 경우
  failedDuplicateLogout, // 중복로그인 차단된 후 접근했을 경우
}

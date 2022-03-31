<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<!-- google api : meta content : OAuth2.0 클라이언트 id -->
<meta name ="google-signin-client_id" content="402831418263-k3hf581l320gep9si4856e6qdu6f5hjs.apps.googleusercontent.com">

<!-- naver api  -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<meta name="viewport" content="width=device-width,initial-scale=1">

<meta charset="EUC-KR">
<title>LOGIN API TEST</title>

<style type="text/css">
 a { color: black;
 	text-decoration: none;
 	font-size:18px;
 	font-weight:bold;
 	}
</style>
</head>

<body>
<h3>LOGIN</h3>

<ul>
	<li id="GgCustomLogin">
		<a href="javascript:void(0)">
		<span>google</span>
		</a>
	</li>
	<li onclick="kakaoLogin();">
		<a href="javascript:void(0)">
		<span>kakao</span>
		</a>
    </li> 
	<li>
		<!-- 아래와 같이 아이디를 꼭 써준다. -->
		<a id="naverIdLogin_loginButton" href="javascript:void(0)">
		<span>naver login</span>
		</a>
	</li>
	<li onclick="naverLogout(); return false;">
		<a href="javascript:void(0)">
		<span>naver logout</span>
		</a>
	</li>
</ul>

<!-- google login -->
<script src="https://apis.google.com/js/platform.js?onload=init" async defer></script>
<script>
function init() {
	gapi.load('auth2', function() {
		gapi.auth2.init();
		options = new gapi.auth2.SigninOptionsBuilder();
		options.setPrompt('select_account');
        // 추가는 Oauth 승인 권한 추가 후 띄어쓰기 기준으로 추가
		options.setScope('email profile openid https://www.googleapis.com/auth/user.birthday.read');
        // 인스턴스의 함수 호출 - element에 로그인 기능 추가
        // GgCustomLogin은 li태그안에 있는 ID, 위에 설정한 options와 아래 성공,실패시 실행하는 함수들
		gapi.auth2.getAuthInstance().attachClickHandler('GgCustomLogin', options, onSignIn, onSignInFailure);
	})
}

function onSignIn(googleUser) {
	var access_token = googleUser.getAuthResponse().access_token
	$.ajax({
    	// people api를 이용하여 프로필 및 생년월일에 대한 선택동의 후 가져온다.
		url: 'https://people.googleapis.com/v1/people/me'
        // key에 자신의 API 키를 넣습니다.
		, data: {personFields:'birthdays', key:'AIzaSyDSzU4fvIcxKLy_fV0ewGpmeESSJKK-a0Q', 'access_token': access_token}
		, method:'GET'
	})
	.done(function(e){
        //프로필을 가져온다.
		var profile = googleUser.getBasicProfile();
		console.log(profile)
	})
	.fail(function(e){
		console.log(e);
	})
}
function onSignInFailure(t){		
	console.log(t);
}
</script>
<!-- google end -->

<!-- kakao api -->
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script>
  function kakaoLogin() {
    $.ajax({
        url: '/login/getKakaoAuthUrl',
        type: 'get',
        async: false,
        dataType: 'text',
        success: function (res) {
            location.href = res;
        }
    });
  }

  $(document).ready(function() {
      var kakaoInfo = '${kakaoInfo}';
      
      if(kakaoInfo != ""){
          var data = JSON.parse(kakaoInfo);
          alert("카카오로그인 성공 \n accessToken : " + data['accessToken']);
          alert(
          "user : \n" + "email : "
          + data['email']  
          + "\n nickname : " 
          + data['nickname']);
      }
  });  
</script>
<!-- kakao end -->

<!-- naver api -->
<script src="https://static.nid.naver.com/js/naveridlogin_js_sdk_2.0.2.js" charset="utf-8"></script>
<script>
var naverLogin = new naver.LoginWithNaverId({
	clientId: "tQBRJfwt63xmym5apdDC", //내 애플리케이션 정보에 cliendId를 입력해줍니다.
	callbackUrl: "http://localhost:8189/naverLogin", // 내 애플리케이션 API설정의 Callback URL 을 입력해줍니다.
	isPopup: false,
	callbackHandle: true
	}
);	

naverLogin.init();

window.addEventListener('load', function () {
	naverLogin.getLoginStatus(function (status) {
		if (status) {
			var email = naverLogin.user.getEmail(); // 필수로 설정할것을 받아와 아래처럼 조건문을 줍니다.
			console.log(naverLogin.user); 
    		
            if( email == undefined || email == null) {
				alert("이메일은 필수정보입니다. 정보제공을 동의해주세요.");
				naverLogin.reprompt();
				return;
			}
		} else {
			console.log("callback 처리에 실패하였습니다.");
		}
	});
});

var testPopUp;
function openPopUp() {
    testPopUp= window.open("https://nid.naver.com/nidlogin.logout", "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,width=1,height=1");
}
function closePopUp(){
    testPopUp.close();
}

function naverLogout() {
	openPopUp();
	setTimeout(function() {
		closePopUp();
		}, 1000);
}
</script>
<!-- naver end -->

</body>
</html>
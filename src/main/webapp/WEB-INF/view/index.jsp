<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<!-- google api : meta content : OAuth2.0 Ŭ���̾�Ʈ id -->
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
		<!-- �Ʒ��� ���� ���̵� �� ���ش�. -->
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
        // �߰��� Oauth ���� ���� �߰� �� ���� �������� �߰�
		options.setScope('email profile openid https://www.googleapis.com/auth/user.birthday.read');
        // �ν��Ͻ��� �Լ� ȣ�� - element�� �α��� ��� �߰�
        // GgCustomLogin�� li�±׾ȿ� �ִ� ID, ���� ������ options�� �Ʒ� ����,���н� �����ϴ� �Լ���
		gapi.auth2.getAuthInstance().attachClickHandler('GgCustomLogin', options, onSignIn, onSignInFailure);
	})
}

function onSignIn(googleUser) {
	var access_token = googleUser.getAuthResponse().access_token
	$.ajax({
    	// people api�� �̿��Ͽ� ������ �� ������Ͽ� ���� ���õ��� �� �����´�.
		url: 'https://people.googleapis.com/v1/people/me'
        // key�� �ڽ��� API Ű�� �ֽ��ϴ�.
		, data: {personFields:'birthdays', key:'AIzaSyDSzU4fvIcxKLy_fV0ewGpmeESSJKK-a0Q', 'access_token': access_token}
		, method:'GET'
	})
	.done(function(e){
        //�������� �����´�.
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
          alert("īī���α��� ���� \n accessToken : " + data['accessToken']);
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
	clientId: "tQBRJfwt63xmym5apdDC", //�� ���ø����̼� ������ cliendId�� �Է����ݴϴ�.
	callbackUrl: "http://localhost:8189/naverLogin", // �� ���ø����̼� API������ Callback URL �� �Է����ݴϴ�.
	isPopup: false,
	callbackHandle: true
	}
);	

naverLogin.init();

window.addEventListener('load', function () {
	naverLogin.getLoginStatus(function (status) {
		if (status) {
			var email = naverLogin.user.getEmail(); // �ʼ��� �����Ұ��� �޾ƿ� �Ʒ�ó�� ���ǹ��� �ݴϴ�.
			console.log(naverLogin.user); 
    		
            if( email == undefined || email == null) {
				alert("�̸����� �ʼ������Դϴ�. ���������� �������ּ���.");
				naverLogin.reprompt();
				return;
			}
		} else {
			console.log("callback ó���� �����Ͽ����ϴ�.");
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
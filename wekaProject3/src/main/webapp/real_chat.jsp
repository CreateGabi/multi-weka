<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MyWeb Chatting</title>
<script type="text/javascript"
	src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<!-- Latest compiled and minified CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Latest compiled JavaScript -->
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<style type="text/css">
* {
	font-family: 나눔고딕;
}

#messageWindow {
	background: black;
	color: greenyellow;
}

#inputMessage {
	width: 500px;
	height: 20px
}

#btn-submit {
	background: white;
	background: #F7E600;
	width: 60px;
	height: 30px;
	color: #607080;
	border: none;
}

#main-container {
	width: 600px;
	height: 680px;
	border: 1px solid black;
	margin: 10px;
	display: inline-block;
}

#chat-container {
	vertical-align: bottom;
	border: 1px solid black;
	margin: 10px;
	min-height: 600px;
	max-height: 600px;
	overflow: scroll;
	overflow-x: hidden;
	background: #9bbbd4;
}

.chat {
	font-size: 20px;
	color: black;
	margin: 5px;
	min-height: 20px;
	padding: 5px;
	min-width: 50px;
	text-align: left;
	height: auto;
	word-break: break-all;
	background: #ffffff;
	width: auto;
	display: inline-block;
	border-radius: 10px 10px 10px 10px;
}

.notice {
	color: #607080;
	font-weight: bold;
	border: none;
	text-align: center;
	background-color: #9bbbd4;
	display: block;
}

.my-chat {
	text-align: right;
	background: #F7E600;
	border-radius: 10px 10px 10px 10px;
}

#bottom-container {
	margin: 10px;
}

.chat-info {
	color: #556677;
	font-size: 10px;
	text-align: right;
	padding: 5px;
	padding-top: 0px;
}

.chat-box {
	text-align: left;
}

.my-chat-box {
	text-align: right;
}
</style>
</head>
<body>

	<!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script> -->
	<script src="resources/js/sockjs-0.3.4.js"></script>
	<script src="resources/js/stomp.js"></script>
	<script src="resources/js/webSocketSendToUserApp.js"></script>

	<script type="text/javascript">
		var stompClient = null;

		function setConnected(connected) { //연결 여부에 따라 설정 
			document.getElementById('connect').disabled = connected;
			document.getElementById('disconnect').disabled = !connected;
			document.getElementById('conversationDiv').style.visibility = connected ? 'visible'
					: 'hidden';
			//$('#response').html('')와 동일한 코드 
			document.getElementById('response').innerHTML = '';
		}

		//서버로 연결함. 
		function connect() {
			//chat주소 서버와의 소켓객체 생성
			var socket = new SockJS('${pageContext.request.contextPath}/chat');
			//소켓을 통해 클라이언트 객체 획득 
			stompClient = Stomp.over(socket);
			//소켓 클라이언트를 통해 연결 획득 
			stompClient.connect({}, function(frame) {
				setConnected(true); //연결 설정 
				console.log('Connected: ' + frame);
				//소켓 클라이언트를 통해 챗팅하고 싶은 특정 사이트에 연결 
				//messageOutput : 받은 메시지
				//topic/messages로 가입한 클라이언트에게 messageOutput을 보냄.
				//@SendTo("/topic/messages")와 동일해야함.
				//config.enableSimpleBroker("/topic");와 동일해야함.
				stompClient.subscribe('/topic/messages',
						function(messageOutput) {
							//서버에서 받은 메시지 출력 
							showMessageOutput(JSON.parse(messageOutput.body));
						});
			});
		}

		//서버로 연결 끊음. 
		function disconnect() {
			if (stompClient != null) {
				stompClient.disconnect();
			}
			setConnected(false); //연결끊어졌을 때 설정 변경 
			console.log("Disconnected");
		}

		//서버로 메세지 보냄 
		function sendMessage() {
			//입력한 정보를 가지고 와서 
			var from = document.getElementById('from').value;
			var text = document.getElementById('text').value;
			//url을 /app/cht을 호출하고,data를 json형태의 sring으로 만들어서 보내라. 
			stompClient.send("/app/chat", {}, JSON.stringify({
				'from' : from,
				'text' : text
			}));
		}

		//받은 데이터를 원하는 위치에 넣음. 
		function showMessageOutput(messageOutput) {
			//<p id="response">
			//	<p> 홍길동: 잘지내지?(13:00)</p>
			//</p>
			var response = document.getElementById('response');
			var p = document.createElement('p');
			p.style.wordWrap = 'break-word';
			p.appendChild(document.createTextNode(messageOutput.from + ": "
					+ messageOutput.text + " (" + messageOutput.time + ")"));
			response.appendChild(p);
		}
	</script>
</head>
<body onload="disconnect()">
<br><br>
	<div>
		<div class="input-group mb-3 input-group-lg">
			<span class="input-group-text">닉네임 입력:</span> <input type="text" class="form-control" id="from">
		</div>
		<br />
		<div>
			<button id="connect" onclick="connect();" class="btn btn-danger" style="width:200px">Connect</button>
			<button id="disconnect" disabled="disabled" onclick="disconnect();" style="width:200px" class="btn btn-danger">Disconnect</button>
		</div>
		<br />
		<div id="conversationDiv">
			<input type="text" id="text" placeholder="Write a message..."
				class="form-control" />
			<button id="sendMessage" onclick="sendMessage();"
				class="btn btn-primary">Send</button>
				
			<p id="response" class="alert alert-success"></p>
		</div>
	</div>
	${pageContext.request.contextPath}
</body>
</html>
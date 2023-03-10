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
	font-family: ëëęł ë;
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

		function setConnected(connected) { //ě°ę˛° ěŹëśě ë°ëź ě¤ě  
			document.getElementById('connect').disabled = connected;
			document.getElementById('disconnect').disabled = !connected;
			document.getElementById('conversationDiv').style.visibility = connected ? 'visible'
					: 'hidden';
			//$('#response').html('')ě ëěźí ě˝ë 
			document.getElementById('response').innerHTML = '';
		}

		//ěë˛ëĄ ě°ę˛°í¨. 
		function connect() {
			//chatěŁźě ěë˛ěě ěěźę°ě˛´ ěěą
			var socket = new SockJS('${pageContext.request.contextPath}/chat');
			//ěěźě íľí´ í´ëźě´ě¸í¸ ę°ě˛´ íë 
			stompClient = Stomp.over(socket);
			//ěěź í´ëźě´ě¸í¸ëĽź íľí´ ě°ę˛° íë 
			stompClient.connect({}, function(frame) {
				setConnected(true); //ě°ę˛° ě¤ě  
				console.log('Connected: ' + frame);
				//ěěź í´ëźě´ě¸í¸ëĽź íľí´ ěąííęł  ěśě íšě  ěŹě´í¸ě ě°ę˛° 
				//messageOutput : ë°ě ëŠěě§
				//topic/messagesëĄ ę°ěí í´ëźě´ě¸í¸ěę˛ messageOutputě ëł´ë.
				//@SendTo("/topic/messages")ě ëěźí´ěźí¨.
				//config.enableSimpleBroker("/topic");ě ëěźí´ěźí¨.
				stompClient.subscribe('/topic/messages',
						function(messageOutput) {
							//ěë˛ěě ë°ě ëŠěě§ ěśë Ľ 
							showMessageOutput(JSON.parse(messageOutput.body));
						});
			});
		}

		//ěë˛ëĄ ě°ę˛° ëě. 
		function disconnect() {
			if (stompClient != null) {
				stompClient.disconnect();
			}
			setConnected(false); //ě°ę˛°ëě´ěĄě ë ě¤ě  ëłę˛˝ 
			console.log("Disconnected");
		}

		//ěë˛ëĄ ëŠě¸ě§ ëł´ë 
		function sendMessage() {
			//ěë Ľí ě ëł´ëĽź ę°ě§ęł  ěě 
			var from = document.getElementById('from').value;
			var text = document.getElementById('text').value;
			//urlě /app/chtě í¸ěśíęł ,dataëĽź jsonííě sringěźëĄ ë§ë¤ě´ě ëł´ë´ëź. 
			stompClient.send("/app/chat", {}, JSON.stringify({
				'from' : from,
				'text' : text
			}));
		}

		//ë°ě ë°ě´í°ëĽź ěíë ěěšě ëŁě. 
		function showMessageOutput(messageOutput) {
			//<p id="response">
			//	<p> íę¸¸ë: ěě§ë´ě§?(13:00)</p>
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
			<span class="input-group-text">ëë¤ě ěë Ľ:</span> <input type="text" class="form-control" id="from">
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
package com.multi.weka33;

import java.util.Date;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

@Controller
public class WebSocketController {

	// ws 프로토콜로 요청을 받음.
	@MessageMapping("/chat")
	@SendTo("/topic/messages")
	public OutputMessage send(Message message) {
		System.out.println(message);  // 서버에서 받은 클라이언트의 채팅 내용을 확인
		Date date = new Date();
		int hour = date.getHours();
		int min = date.getMinutes();
		String time = hour + ":" + min;
		// 채팅방에 들어와잇는 모든 클라이언트에게 보낼 데이터
		OutputMessage output = new OutputMessage(message.getFrom(), message.getText(), time);
		return output;  // return 데이터는 json으로 만들어서 클라이언트 브라우저에 보냄.
		//jackson-databind
	}
}

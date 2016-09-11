package cn.zichao.sy;

import org.springframework.boot.SpringApplication;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloSpringBootApplication {

	public static void main(String[] args) {
		SpringApplication.run(HelloSpringBootApplication.class, args);
	}
	public  String hello()
	{
		return  "Hello Docker and Spring boot";
	}
}

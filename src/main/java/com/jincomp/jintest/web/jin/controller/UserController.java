package com.jincomp.jintest.web.jin.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;

import com.jincomp.jintest.web.jin.service.UserService;
import com.jincomp.jintest.web.jin.vo.UserVO;

@Controller
public class UserController {
	@Autowired
	private static final Logger log = LoggerFactory.getLogger(UserController.class);
	
	@Autowired
	private UserService userService;
	
	@GetMapping("/")  // 처음 DOMAIN 주소로 접근시 jsp 호출용.
	public String showFirstHome(HttpServletRequest request,
		HttpServletResponse response, ModelMap model) throws Exception {
		List<UserVO> list = userService.getSearchUserList("","");
		
		log.debug("list : {}", list);
		
		model.addAttribute("list", list);
		
		return "/main/home";  //home.jsp 로 구성
	}
}

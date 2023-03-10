package com.jincomp.jintest.web.jin.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.jincomp.jintest.web.jin.service.UserService;
import com.jincomp.jintest.web.jin.vo.UserVO;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@RequestMapping(value = "/main")
@RestController
public class UserRestController {

	private static final Logger logger = LoggerFactory.getLogger(UserRestController.class);

	
	private final UserService userService;

   @RequestMapping(value = "/getUser.do")
   public List<UserVO> tableList(@RequestParam("condition") String condition, @RequestParam("input") String input,
		   HttpServletRequest request, HttpServletResponse response) throws Exception {
	   List<UserVO> list;
	   list = userService.getSearchUserList(condition, input);
	   
	   logger.debug("input : {}", input);
	   logger.debug("condition : {}", condition);
       logger.debug("list : {}",list);

       return list;
   }
   
   @RequestMapping(value = "/addUser.do")
   public void addUser(@RequestBody UserVO emp, HttpServletRequest request, HttpServletResponse response) {
	    logger.debug("empName : {} empBirthDate : {} empGender : {}",
	    		emp.getName(), emp.getBirthDate(), emp.getGender());
	    
	    userService.addUser(emp);
   }
   
   @RequestMapping(value = "/updateUser.do")
   public int updateUser(@RequestBody UserVO updateEmp, HttpServletRequest request, HttpServletResponse response) throws Exception {
	   
	   logger.debug("updateEmp : {}", updateEmp);
	   
	   return userService.updateUser(updateEmp);
	    
   }
   
   @RequestMapping(value = "/delUser.do")
   public void delUser(@RequestParam("empNoList[]") List<String> empNoList,
		   HttpServletRequest request, HttpServletResponse response) throws Exception {
	   
	  logger.debug("empNoList : {}", empNoList);
	  
	  userService.deleteUser(empNoList);  
   }
   
   
}

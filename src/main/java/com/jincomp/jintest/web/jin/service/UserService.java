package com.jincomp.jintest.web.jin.service;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.jincomp.jintest.web.jin.mapper.UserMapper;
import com.jincomp.jintest.web.jin.vo.UserVO;

import lombok.RequiredArgsConstructor;

/**
 *
 * @author kyj
 */
@RequiredArgsConstructor
@Service
public class UserService {

	private static final Logger logger = LoggerFactory.getLogger(UserService.class);
	
	private final UserMapper userMapper;
	
	public List<UserVO> getSearchUserList(String condition, String input){
		logger.debug("getSearchUserList 진입");
		logger.debug("진입후 condition : {}", condition);
		logger.debug("진입후 input : {}", input);
		
		if(input.length() > 0) {
			return userMapper.getSearchUserList(condition, input);
		} else {
			return userMapper.getUserList();
		}
	}
	
	public void deleteUser(List<String> empNo){
		logger.debug("delUser 진입");
		List<Integer> tmp = new ArrayList<>();
		for(String num : empNo) {
			tmp.add(Integer.parseInt(num));		// 스트링형을 int형으로 변환하여 리스트를 생성
		}
		logger.debug("intList", tmp);
 		userMapper.deleteUser(tmp);
	}
	
	public void addUser(UserVO emp) {
		int startIndex = 10001;			// 사원번호의 시작 인덱스
		int tmp;
		
		logger.debug("addUser 진입");
		List<Integer> empNoList = new ArrayList<>();		// 사원번호의 리스트
		List<UserVO> empList = userMapper.getUserList();	
		for(UserVO user : empList) {						// 사원의 리스트를 가져와 iterating해 사원번호의 리스트를 만듬
			empNoList.add(Integer.parseInt(user.getEmpNo()));
		}
		
		// 사원번호 빈 값 찾기
		if(empNoList.contains(startIndex)) {	// 사원리스트의 사원번호가 시작번호(10001)가 있을 경우
			for(int empNo : empNoList) {
				tmp = empNo + 1;
				if(!empNoList.contains(tmp)) {	// 리스트 순회하며 해당 요소의 숫자+1이 있다면 넘어가고 없으면 그 숫자+1를 empNo에 추가한다.
					logger.debug("리스트에 중간에 빠진 번호 {}",tmp);
					emp.setEmpNo(String.valueOf(tmp));
					break;
				}
			}
		} else {	// 10001번이 없는경우(시작 기준번호부터 없을 경우)
			logger.debug("리스트 시작번호가 없을때 {}", startIndex);
			emp.setEmpNo(String.valueOf(startIndex)); 		// 시작 기준번호를 사원번호로
		}
		String hireDate = (LocalDate.now()).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
		logger.debug("입사일자 {}", hireDate);
		emp.setHireDate(hireDate);	// 숫자 8자리로만 이루어진 날짜 스트링 형태로 추가
		
		logger.debug("비지니스 로직 후 emp {}",emp);
		userMapper.addUser(emp);
	}
	
	public int updateUser(UserVO updateEmp) {
		logger.debug("updateUser 진입");
		List<UserVO> targetEmp = userMapper.getSearchUserList("emp_no", updateEmp.getEmpNo());
		if(targetEmp.get(0).equals(updateEmp)) {
			logger.debug("--------업데이트정보가 기존 정보와 차이없는 경우");
			return 0;
		}
		else {
			logger.debug("--------업데이트정보가 기존 정보와 다를 경우");
			return userMapper.updateUser(updateEmp);
		}
	}
}

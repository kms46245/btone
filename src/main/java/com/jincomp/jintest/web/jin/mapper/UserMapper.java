package com.jincomp.jintest.web.jin.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.jincomp.jintest.web.jin.vo.UserVO;

@Mapper
public interface UserMapper {

	List<UserVO> getUserList();
	List<UserVO> getSearchUserList(@Param("condition") String condition,
									@Param("input") String input);
	void addUser(UserVO emp);
	int updateUser(UserVO updateEmp);
	void deleteUser(@Param("empNo") List<Integer> empNo);
}

package com.jincomp.jintest.web.jin.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@NoArgsConstructor
@AllArgsConstructor
@Data
@Getter
@Setter
public class UserLoginVO {
	private int userNo;
   private String userName;
   private String userId;
   private String userPassword;
   private String userAddress;
}
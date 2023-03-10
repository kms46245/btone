package com.jincomp.jintest.web.jin.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@AllArgsConstructor
@Data
@Getter
@Setter
public class SearchVO {
	private String condition;
	private String input;
}

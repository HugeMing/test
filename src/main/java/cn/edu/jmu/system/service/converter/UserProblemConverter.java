package cn.edu.jmu.system.service.converter;

import cn.edu.jmu.system.entity.Solution;
import cn.edu.jmu.system.entity.UserProblem;
import cn.edu.jmu.system.entity.dto.SolutionCodeDto;
import cn.edu.jmu.system.entity.dto.SolutionDto;
import cn.edu.jmu.system.entity.dto.UserProblemDto;
import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.bean.copier.CopyOptions;

public class UserProblemConverter {

    private UserProblemConverter(){

    }

    public static UserProblemDto toDto(UserProblem userProblem) {
        UserProblemDto userProblemDto = new UserProblemDto();
        BeanUtil.copyProperties(userProblem, userProblemDto, true, CopyOptions.create().setIgnoreNullValue(true));
        return userProblemDto;
    }

    public static UserProblem toEntity(UserProblemDto userProblemDto) {
        UserProblem userProblem = new UserProblem();
        BeanUtil.copyProperties(userProblemDto, userProblem, true, CopyOptions.create().setIgnoreNullValue(true));
        return userProblem;
    }
}

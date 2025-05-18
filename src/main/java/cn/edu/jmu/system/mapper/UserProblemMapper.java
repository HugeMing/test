package cn.edu.jmu.system.mapper;

import cn.edu.jmu.system.entity.User;
import cn.edu.jmu.system.entity.UserProblem;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.apache.ibatis.annotations.Select;

/**
 * @author xeathen
 * @date 2019/10/5 10:29
 */
public interface UserProblemMapper extends BaseMapper<UserProblem> {
    @Select("SELECT SUM(`submit`) AS `total` FROM `user_problems` WHERE `uid`=#{userId}")
    Integer countSubmit(Integer userId);


    @Select("SELECT SUM(`submit`) AS `total` FROM `user_problems` WHERE `uid`=#{userId} AND `pcid`=#{pcId}")
    Integer countUserCategorySubmit(Integer userId, Integer pcId);

    @Select("SELECT SUM(`passed`) AS `total` FROM `user_problems` WHERE `uid`=#{userId} AND `pcid`=#{pcId} AND `passed`=#{passed}")
    Integer countUserCategoryPassed(Integer userId, Integer pcId, boolean passed);

}

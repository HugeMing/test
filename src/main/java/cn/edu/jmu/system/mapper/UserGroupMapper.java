package cn.edu.jmu.system.mapper;

import cn.edu.jmu.system.entity.UserGroup;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;

/**
 * @author xeathen
 */
public interface UserGroupMapper extends BaseMapper<UserGroup> {
    @Select("SELECT * FROM sys_user_groups limit #{skip}, #{limit}")
    List<UserGroup> list(Integer skip, Integer limit);

    @Select("SELECT COUNT(1) FROM sys_user_groups")
    Long count();

    @Select(("SELECT id FROM sys_user_groups WHERE name=#{name}"))
    Integer getByName(String name);
}

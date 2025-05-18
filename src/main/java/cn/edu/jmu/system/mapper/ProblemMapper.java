package cn.edu.jmu.system.mapper;

import cn.edu.jmu.system.entity.Problem;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * @author LGiki
 * @date 2019/06/21 13:19
 */

public interface ProblemMapper extends BaseMapper<Problem> {
    Integer getProblemAnswer(@Param("problemId") Integer problemId);

    String getTrueResult(@Param("problemId") Integer problemId);

}
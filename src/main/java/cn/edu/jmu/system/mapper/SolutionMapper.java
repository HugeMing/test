package cn.edu.jmu.system.mapper;

import cn.edu.jmu.system.entity.Solution;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

/**
 * @author LGiki
 * @date 2019/06/22 15:15
 */
public interface SolutionMapper extends BaseMapper<Solution> {
    Integer getProblemId(@Param("solutionId") Integer solutionId);
    String getSourceCode(@Param("solutionId") Integer solutionId);

    String getProblemAnswer(@Param("problemId") Integer problemId);

    String getTrueResult(@Param("problemId") Integer problemId);
}
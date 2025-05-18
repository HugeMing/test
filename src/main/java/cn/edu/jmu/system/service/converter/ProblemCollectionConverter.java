package cn.edu.jmu.system.service.converter;

import cn.edu.jmu.system.entity.Problem;
import cn.edu.jmu.system.entity.ProblemCollection;
import cn.edu.jmu.system.entity.Solution;
import cn.edu.jmu.system.entity.dto.ProblemCollectionDto;
import cn.edu.jmu.system.entity.dto.SolutionDto;
import cn.hutool.core.bean.BeanUtil;
import cn.hutool.core.bean.copier.CopyOptions;

/**
 * @author Ethan
 */
public class ProblemCollectionConverter {

    public static ProblemCollectionDto problemCollectionDto(ProblemCollection problemCollection) {
        ProblemCollectionDto problemCollectionDto = new ProblemCollectionDto();
        BeanUtil.copyProperties(problemCollection, problemCollectionDto);
        return problemCollectionDto;
    }

    public static ProblemCollection toEntity(ProblemCollectionDto problemCollectionDto) {
        ProblemCollection problemCollection = new ProblemCollection();
        BeanUtil.copyProperties(problemCollectionDto,problemCollection, true, CopyOptions.create().setIgnoreNullValue(true));
        return problemCollection;
    }
}

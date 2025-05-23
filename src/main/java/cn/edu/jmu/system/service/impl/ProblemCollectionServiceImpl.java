package cn.edu.jmu.system.service.impl;

import cn.edu.jmu.system.api.problemcollection.CreateProblemCollectionRequest;
import cn.edu.jmu.system.api.problemcollection.CreateProblemCollectionResponse;
import cn.edu.jmu.system.entity.Database;
import cn.edu.jmu.system.entity.Problem;
import cn.edu.jmu.system.entity.ProblemCollection;
import cn.edu.jmu.system.entity.UserProblem;
import cn.edu.jmu.system.entity.dto.ProblemCollectionDto;
import cn.edu.jmu.system.mapper.ProblemCollectionMapper;
import cn.edu.jmu.system.service.DatabaseService;
import cn.edu.jmu.system.service.ProblemCategoryService;
import cn.edu.jmu.system.service.ProblemCollectionService;
import cn.edu.jmu.system.service.ProblemService;
import cn.edu.jmu.system.service.converter.ProblemCollectionConverter;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.conditions.update.UpdateWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author xeathen
 */
@Service
public class ProblemCollectionServiceImpl extends ServiceImpl<ProblemCollectionMapper, ProblemCollection> implements ProblemCollectionService {
    @Resource
    ProblemCategoryService problemCategoryService;
    @Resource
    ProblemService problemService;
    @Resource
    DatabaseService databaseService;
    @Resource
    ProblemCollectionMapper problemCollectionMapper;

    @Override
    public IPage<ProblemCollectionDto> search(ProblemCollectionDto problemCollectionDto, Page<ProblemCollection> page) {
        Page<ProblemCollection> problemCollectionPage = new Page<>(page.getCurrent(), page.getSize());
        //IPage<ProblemCollection> iPage = baseMapper.selectPage(problemCollectionPage, predicate(problemCollectionDto));
        IPage<ProblemCollection> iPage = baseMapper.selectPage(problemCollectionPage, new QueryWrapper<>(ProblemCollectionConverter
                .toEntity(problemCollectionDto)).lambda().orderByAsc(ProblemCollection::getProblemId));
        return iPage.convert(this::convertProblemCollectionToProblemCollectionDto);
    }

    private ProblemCollectionDto convertProblemCollectionToProblemCollectionDto(ProblemCollection problemCollection) {
        ProblemCollectionDto problemCollectionDto = ProblemCollectionConverter.problemCollectionDto(problemCollection);
        Problem problem = problemService.getById(problemCollection.getProblemId());
        problemCollectionDto.setProblemTitle(problem.getTitle());
        problemCollectionDto.setProblemDifficulty(problem.getDifficulty());
        Database database = databaseService.getById(problem.getDatabaseId());
        problemCollectionDto.setDatabaseId(database.getId());
        problemCollectionDto.setDatabaseName(database.getName());
        return problemCollectionDto;
    }

    private Wrapper<ProblemCollection> predicate(ProblemCollectionDto problemCollectionDto) {
        if (problemCollectionDto == null) {
            return null;
        } else {
            LambdaQueryWrapper<ProblemCollection> queryWrapper = new LambdaQueryWrapper<>();
            if (problemCollectionDto.getId() != null) {
                queryWrapper.eq(ProblemCollection::getId, problemCollectionDto.getId());
            }
            if (problemCollectionDto.getCategoryId() != null) {
                queryWrapper.eq(ProblemCollection::getCategoryId, problemCollectionDto.getCategoryId());
            }
            if (problemCollectionDto.getProblemId() != null) {
                queryWrapper.eq(ProblemCollection::getProblemId, problemCollectionDto.getProblemId());
            }
            return queryWrapper;
        }
    }

    @Override
    public CreateProblemCollectionResponse create(CreateProblemCollectionRequest request) {
        ProblemCollection problemCollection = new ProblemCollection();
        problemCollection.setCategoryId(request.getCategoryId());
        problemCollection.setProblemId(request.getProblemId());
        baseMapper.insert(problemCollection);
        CreateProblemCollectionResponse response = new CreateProblemCollectionResponse();
        response.setId(problemCollection.getId());
        return response;
    }

    @Override
    public Boolean delete(Integer id) {
        return baseMapper.deleteById(id) >= 1;
    }

    @Override
    public Boolean isExistByProblemIdAndProblemCategoryId(Integer problemId, Integer problemCategoryId) {
        return baseMapper.selectCount(Wrappers.<ProblemCollection>lambdaQuery().eq(ProblemCollection::getProblemId, problemId).eq(ProblemCollection::getCategoryId, problemCategoryId)) > 0;
    }

    @Override
    public Integer findByProblemIdAndProblemCategoryId(Integer problemId, Integer problemCategoryId) {
        ProblemCollection problemCollection = new ProblemCollection();
        problemCollection.setProblemId(problemId);
        problemCollection.setCategoryId(problemCategoryId);
        ProblemCollection selectOne = query(problemCollection);
        if (selectOne == null) {
            return 0;
        } else {
            return selectOne.getId();
        }
    }

    private ProblemCollection query(ProblemCollection problemCollection) {
        QueryWrapper<ProblemCollection> queryWrapper = new QueryWrapper<>(problemCollection);
        return baseMapper.selectOne(queryWrapper);
    }

    @Override
    public List<Integer> getProblemIdsByProblemCategoryId(Integer problemCategoryId) {
        return baseMapper.selectList(Wrappers.<ProblemCollection>lambdaQuery().eq(ProblemCollection::getCategoryId, problemCategoryId)).stream().map(ProblemCollection::getProblemId).collect(Collectors.toList());
    }

    @Override
    public Boolean existById(Integer id) {
        return baseMapper.selectCount(Wrappers.<ProblemCollection>lambdaQuery().eq(ProblemCollection::getId, id)) != 0;
    }

    @Override
    public Boolean updateProblemScoreById(Integer id, Integer problemScore) {
        if (this.existById(id)) {
            return problemCollectionMapper.updateProblemScoreById(id, problemScore) >= 1;
        } else {
            return false;
        }
    }
}

package cn.edu.jmu.system.service.impl;

import cn.edu.jmu.system.entity.*;
import cn.edu.jmu.system.entity.dto.UserProblemDto;
import cn.edu.jmu.system.mapper.UserProblemMapper;
import cn.edu.jmu.system.service.ProblemService;
import cn.edu.jmu.system.service.UserProblemService;
import cn.edu.jmu.system.service.UserService;
import cn.edu.jmu.system.service.converter.UserProblemConverter;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.Wrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

/**
 * @author xeathen
 * @date 2019/10/5 10:36
 */
@Service
public class UserProblemServiceImpl extends ServiceImpl<UserProblemMapper, UserProblem> implements UserProblemService {

    @Resource
    UserProblemMapper userProblemMapper;

    @Resource
    private UserService userService;

    @Resource
    private ProblemService problemService;
    /**
     * @param userId    用户ID
     * @param problemId 题目ID
     */
    @Override
    public Integer find(Integer userId, Integer problemId) {
        UserProblem userProblem = new UserProblem();
        userProblem.setUid(userId);
        userProblem.setPid(problemId);
        UserProblem selectOne = query(userProblem);
        if (selectOne == null) {
            return 0;
        } else {
            return selectOne.getId();
        }
    }

    /**
     * @param userId 用户ID
     * @param problemId 题目ID
     * @param passed 是否通过
     */
    @Override
    public Integer find(Integer userId, Integer problemId, Boolean passed) {
        UserProblem userProblem = new UserProblem();
        userProblem.setUid(userId);
        userProblem.setPid(problemId);
        userProblem.setPassed(passed);
        UserProblem selectOne = query(userProblem);
        if (selectOne == null) {
            return 0;
        } else {
            return selectOne.getId();
        }
    }

    @Override
    public Integer countPassed(Integer userId, Boolean passed) {
        return baseMapper.selectCount(Wrappers.<UserProblem>lambdaQuery().eq(UserProblem::getUid, userId).eq(UserProblem::getPassed, passed));
    }

    @Override
    public Integer countSubmit(Integer userId) {
        return userProblemMapper.countSubmit(userId);
    }

    @Override
    public Integer countCategoryPassed(Integer userId, Integer categoryId) {
        //return baseMapper.selectCount(Wrappers.<UserProblem>lambdaQuery().eq(UserProblem::getUid, userId).eq(UserProblem::getProblemCategoryId, categoryId).eq(UserProblem::getPassed, true));
        return userProblemMapper.countUserCategoryPassed(userId, categoryId, true);
    }

    @Override
    public Integer countCategorySubmit(Integer userId, Integer categoryId) {
        //return baseMapper.selectCount(Wrappers.<UserProblem>lambdaQuery().eq(UserProblem::getUid, userId).eq(UserProblem::getProblemCategoryId, categoryId));
        return userProblemMapper.countUserCategorySubmit(userId, categoryId);
    }

    private UserProblem query(UserProblem userProblem) {
        QueryWrapper<UserProblem> queryWrapper = new QueryWrapper<>(userProblem);
        return baseMapper.selectOne(queryWrapper);
    }

    /**
     * 通过用户ID、题目集ID、通过状态查找题目ID集合
     *
     * @param userId            用户ID
     * @param problemCategoryId 题目集ID
     * @param passed            是否通过
     * @return List<Integer> 题目ID列表
     */
    @Override
    public List<Integer> findByUserIdAndProblemCategoryIdAndPassed(Integer userId, Integer problemCategoryId, Boolean passed) {
        return baseMapper.selectList(Wrappers.<UserProblem>lambdaQuery().eq(UserProblem::getUid, userId).eq(UserProblem::getProblemCategoryId, problemCategoryId).eq(UserProblem::getPassed, passed)).stream().map(UserProblem::getPid).collect(Collectors.toList());
    }

    /**
     * 根据题目集ID 获取rank榜单
     * @param userProblemDto
     * @param page
     * @return
     */
    @Override
    public IPage<UserProblemDto> getAll(UserProblemDto userProblemDto, Page page) {
        Page<UserProblem> userProblemPage = new Page<>(page.getCurrent(), page.getSize());
        IPage<UserProblem> iPage = null;
        Integer pcid = userProblemDto.getProblemCategoryId();
//        if (ObjectUtil.isNull(userProblemDto)) {
//            iPage = baseMapper.selectPage(userProblemPage
//                    , Wrappers.<UserProblem>lambdaQuery().orderByDesc(UserProblem::getId));
//        } else {
//            if (userProblemDto.getProblemCategoryId() != null) {
//                iPage = baseMapper.selectPage(userProblemPage
//                        , new QueryWrapper<>(UserProblemConverter
//                                .toEntity(userProblemDto)).lambda().like(UserProblem::getProblemCategoryId, "%" + userProblemDto.getProblemCategoryId() + "%")
//                                .groupBy(UserProblem::getUid));
//            }
//        }
        String sql = "uid, SUM(passed) AS total";
        iPage = baseMapper.selectPage(userProblemPage,
                Wrappers.<UserProblem>query().select(sql).eq("pcid", userProblemDto.getProblemCategoryId()).groupBy("uid").orderByDesc("total"));

        IPage<UserProblemDto> convert = iPage.convert(UserProblemConverter::toDto);
        //查询出来的结果只有uid，没有pcid，所以再次添加pcid
        List<UserProblemDto> convertList = convert.getRecords();
        for(int i = 0; i < convertList.size(); i++){
            convertList.get(i).setProblemCategoryId(pcid);
            convert.setRecords(convertList);
        }
        convert.getRecords().forEach(this::addMessage);
        //再次排序
        List<UserProblemDto> list = convert.getRecords();
        Collections.sort(list, (o1, o2) -> o2.getSolved().compareTo(o1.getSolved()));
        for(int i = 0; i < list.size(); i++){
            convert.setRecords(list);
        }
        return convert;
    }

    @Override
    public IPage<UserProblemDto> getRank(UserProblemDto userProblemDto, Page page) {
        Page<UserProblem> userProblemPage = new Page<>(page.getCurrent(), page.getSize());
        String sql = "uid, SUM(passed) AS total";

        IPage<UserProblem> iPage = baseMapper.selectPage(userProblemPage,
                Wrappers.<UserProblem>query().select(sql).groupBy("uid").orderByDesc("total"));

        IPage<UserProblemDto> convert = iPage.convert(UserProblemConverter::toDto);
        convert.getRecords().forEach(this::addRankMessage);
        List<UserProblemDto> list = convert.getRecords();
        Collections.sort(list, (o1, o2) -> o2.getSolved().compareTo(o1.getSolved()));
        for(int i = 0; i < list.size(); i++){
            convert.setRecords(list);
        }
        return convert;
    }

    /**
     * 在solutionDto中增加Username和title
     */
    private void addMessage(UserProblemDto userProblemDto) {
        User user = userService.getById(userProblemDto.getUid());
        if (user != null) {
            System.out.println(user.getUsername());
            userProblemDto.setUsername(user.getUsername());
            userProblemDto.setStudentNo(user.getStudentNo());
        }
        if(ObjectUtil.isNull(countCategoryPassed(userProblemDto.getUid(), userProblemDto.getProblemCategoryId()))) {
            userProblemDto.setSolved(0);
        }else {
            userProblemDto.setSolved(countCategoryPassed(userProblemDto.getUid(), userProblemDto.getProblemCategoryId()));
        }
        int submited = countCategorySubmit(userProblemDto.getUid(), userProblemDto.getProblemCategoryId());
        userProblemDto.setSubmit(submited);
    }

    private void addRankMessage(UserProblemDto userProblemDto) {
        User user = userService.getById(userProblemDto.getUid());
        if (user != null) {
            userProblemDto.setUsername(user.getUsername());
            userProblemDto.setStudentNo(user.getStudentNo());
        }
        if(ObjectUtil.isNull(countPassed(userProblemDto.getUid(), true))) {
            userProblemDto.setSolved(0);
        }else {
            userProblemDto.setSolved(countPassed(userProblemDto.getUid(), true));
        }
        int submited = countSubmit(userProblemDto.getUid());
        userProblemDto.setSubmit(submited);
    }
}

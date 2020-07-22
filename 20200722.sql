오라클 계층 쿼리:하나의 테이블(혹은 인라인 뷰) 에서특정 행을 기준으로 다른행을 찾아가는 문법
조인:테이블과 테이블 연결
계층쿼리:행과 행을 연결

1.시작점(행)을 설정
2.시작점(행)과 다른행을 연결시킬 조건을 기술

1.시작점:mgr 정보가 없는 KING
2.연결 조건:KING을 MGR컬럼으로하는 사원

SELECT LPAD(' ',(LEVEL-1)*4) || ename,LEVEL
from EMP
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

최하단 노드에서 상위 노드로 연결하는 상향식 연결방법
시작점:SMITH

PRIOR 키워드는 CONNECT BY 키워드와 떨어져서 사용해도 무관
SELECT LPAD(' ',(LEVEL-1)*4) || ename,emp.*
FROM emp
START WITH ename = 'SMITH'
CONNECT BY PRIOR mgr = empno;

데이터 입력
create table dept_h (
    deptcd varchar2(20) primary key ,
    deptnm varchar2(40) not null,
    p_deptcd varchar2(20),
    
    CONSTRAINT fk_dept_h_to_dept_h FOREIGN KEY
    (p_deptcd) REFERENCES  dept_h (deptcd) 
);

insert into dept_h values ('dept0', 'XX회사', '');
insert into dept_h values ('dept0_00', '디자인부', 'dept0');
insert into dept_h values ('dept0_01', '정보기획부', 'dept0');
insert into dept_h values ('dept0_02', '정보시스템부', 'dept0');
insert into dept_h values ('dept0_00_0', '디자인팀', 'dept0_00');
insert into dept_h values ('dept0_01_0', '기획팀', 'dept0_01');
insert into dept_h values ('dept0_02_0', '개발1팀', 'dept0_02');
insert into dept_h values ('dept0_02_1', '개발2팀', 'dept0_02');
insert into dept_h values ('dept0_00_0_0', '기획파트', 'dept0_01_0');
commit;


SELECT *
FROM dept_h;
XX회사 부서부터 시작하는 하향식 계층쿼리 작성,부서이름과 LEVEL 컬럼을 이용하여 들여쓰기 표현
SELECT LPAD(' ',(LEVEL-1)*4) || deptnm,level
FROM dept_h
START WITH deptnm = '디자인팀'
CONNECT BY PRIOR p_deptcd = deptcd;


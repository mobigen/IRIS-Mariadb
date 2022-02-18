CREATE DATABASE IF NOT EXISTS WAS DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;

-- 서비스별 데이터 버전 테이블(for migration)
CREATE TABLE IF NOT EXISTS WAS.WAS_SERVICE_VERSIONS (
    `SERVICE_ID`    varchar(50) NOT NULL,
    `VERSION`       text        NOT NULL,
    `EDIT_DATE`     text        DEFAULT NULL,

    PRIMARY KEY (`SERVICE_ID`)
) DEFAULT CHARSET=utf8;

/**
*   meta
*/

-- 사용자 계정
CREATE TABLE IF NOT EXISTS WAS.WAS_USER (
    `ID`            varchar(50) NOT NULL,
    `ROLE_CODE`     text        DEFAULT NULL,
    `GROUP_ID`      text        DEFAULT NULL,
    `PASSWD`        text        DEFAULT NULL,
    `CREATE_DATE`   text        DEFAULT NULL,
    `DESCRIPTION`   text        DEFAULT NULL,
    `NAME`          text        DEFAULT NULL,
    `EMAIL`         text        DEFAULT NULL,
    `PHONE`         text        DEFAULT NULL,
    `ETC`           text        DEFAULT NULL,

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

-- 사용자 그룹
CREATE TABLE IF NOT EXISTS WAS.WAS_GROUP (
    `ID`            varchar(50) NOT NULL,
    `NAME`          text        DEFAULT NULL,
    `DESCRIPTION`   text        DEFAULT NULL,
    `DEFAULT`       text        DEFAULT 'false',

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

-- 사용자 계정: 역할 코드
CREATE TABLE IF NOT EXISTS WAS.WAS_ROLE (
    `CODE`          varchar(50) NOT NULL,
    `NAME`          text        DEFAULT NULL,
    `DESCRIPTION`   text        DEFAULT NULL,

    PRIMARY KEY (`CODE`)
) DEFAULT CHARSET=utf8;

-- 권한
CREATE TABLE IF NOT EXISTS WAS.WAS_ACCESS_RIGHTS (
    `ID`            text        DEFAULT NULL,
    `CATEGORY`      text        DEFAULT NULL,
    `TYPE`          text        DEFAULT NULL,
    `VALUE`         text        DEFAULT NULL
) DEFAULT CHARSET=utf8;

-- 권한 잠금
CREATE TABLE IF NOT EXISTS WAS.WAS_ACCESS_RIGHTS_LOCK (
    `ID`            text        DEFAULT NULL,
    `CATEGORY`      text        DEFAULT NULL
) DEFAULT CHARSET=utf8;

-- 회원 가입
CREATE TABLE IF NOT EXISTS WAS.WAS_SIGN_UP (
    `ID`            varchar(50) NOT NULL,
    `PASSWD`        text        NOT NULL,
    `NAME`          text        DEFAULT NULL,
    `PHONE`         text        DEFAULT NULL,
    `EMAIL`         text        DEFAULT NULL,
    `MESSAGE`       text        DEFAULT NULL,
    `REQ_DATE`      text        NOT NULL,
    `STATUS`        text        NOT NULL,
    `STATUS_DATE`   text        NOT NULL,
    `ETC`           text        DEFAULT NULL
) DEFAULT CHARSET=utf8;

-- 사용자 계정 필드 정보
CREATE TABLE IF NOT EXISTS WAS.WAS_USER_FIELD (
    `ID`            varchar(50) COLLATE utf8_unicode_ci NOT NULL,
    `TYPE`          text        COLLATE utf8_unicode_ci DEFAULT 'TEXT',
    `MAX_LENGTH`    text        COLLATE utf8_unicode_ci DEFAULT NULL,
    `REQUIRED`      text        COLLATE utf8_unicode_ci DEFAULT 'false',
    `USED`          text        COLLATE utf8_unicode_ci DEFAULT 'false',
    `LIST_DISPLAY`  text        COLLATE utf8_unicode_ci DEFAULT 'false',
    `ORDER`         text        COLLATE utf8_unicode_ci NOT NULL,

  PRIMARY KEY (`ID`),
  KEY WAS_USER_FIELD (`ID`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
;

-- 사용자 계정 필드 정보: l10n
CREATE TABLE IF NOT EXISTS WAS.WAS_USER_FIELD_L10N (
    `USER_FIELD_ID` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
    `LOCALE`        text        COLLATE utf8_unicode_ci DEFAULT 'ko',
    `TYPE`          text        COLLATE utf8_unicode_ci DEFAULT NULL,
    `VALUE`         text        COLLATE utf8_unicode_ci DEFAULT NULL,

    CONSTRAINT `WAS_USER_FIELD_L10N_ibfk_1` FOREIGN KEY (`USER_FIELD_ID`) REFERENCES WAS.`WAS_USER_FIELD` (`ID`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
;

-- 감사 로그
CREATE TABLE IF NOT EXISTS WAS.WAS_AUDIT_LOG (
    `TYPE`          text        DEFAULT NULL,
    `MENU_ID`       varchar(50) DEFAULT NULL,
    `USER_ID`       varchar(50) DEFAULT NULL,
    `IP`            text        DEFAULT NULL,
    `DATE`          datetime    DEFAULT NULL,
    `ETC`           mediumtext  DEFAULT NULL
) DEFAULT CHARSET=utf8;

/**
*   Analyzer
*/

-- 검색 이력
CREATE TABLE IF NOT EXISTS WAS.WAS_LOG_QUERY_HIST (
    `USER_ID`       text        NOT NULL,
    `START_DATE`    text        DEFAULT NULL,
    `END_DATE`      text        DEFAULT NULL,
    `DATAMODEL`     text        NOT NULL,
    `QUERY`         text        NOT NULL,
    `TYPE`          text        NOT NULL,
    `ETC`           text        DEFAULT NULL,
    `EXECUTE_TIME`  text        NOT NULL
) DEFAULT CHARSET=utf8;

-- 분석 템플릿
CREATE TABLE IF NOT EXISTS WAS.WAS_VISUAL (
    `ID`            varchar(50) NOT NULL,
    `USER_ID`       text        NOT NULL,
    `NAME`          text        NOT NULL,
    `TYPE`          text        NOT NULL,
    `ETC`           mediumtext  DEFAULT NULL,
    `EDIT_DATE`     text        DEFAULT NULL,

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

/**
*   Studio
*/

-- 보고서
CREATE TABLE IF NOT EXISTS WAS.WAS_REPORT (
    `ID`            varchar(50) NOT NULL,
    `USER_ID`       text        NOT NULL,
    `NAME`          text        NOT NULL,
    `DASHBOARD`     text        NOT NULL,
    `ETC`           mediumtext  DEFAULT NULL,
    `EDIT_DATE`     text        DEFAULT NULL,
    `CATEGORY_ID`   varchar(50) DEFAULT NULL,
    `THUMBNAIL`     mediumblob  DEFAULT NULL,

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

-- 보고서: Chart, Map 객체 데이터
CREATE TABLE IF NOT EXISTS WAS.WAS_VISUAL_REPORT (
    `ID`            varchar(50) NOT NULL,
    `USER_ID`       text        NOT NULL,
    `NAME`          text        DEFAULT NULL,
    `TYPE`          text        NOT NULL,
    `ETC`           mediumtext  DEFAULT NULL,
    `EDIT_DATE`     text        DEFAULT NULL,

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

-- 보고서: Image 객체 데이터
CREATE TABLE IF NOT EXISTS WAS.WAS_REPORT_IMAGE
(
    `REPORT_ID`     varchar(50) NOT NULL,
    `IMAGE_ID`      varchar(80) NOT NULL,
    `IMAGE_BASE64`  mediumtext  NULL,
    `EDIT_DATE`     text        NOT NULL,

    CONSTRAINT `WAS_REPORT_IMAGE_ibfk_1` FOREIGN KEY (`REPORT_ID`) REFERENCES WAS.`WAS_REPORT` (`ID`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8;

-- 보고서: 내보내기 URL
CREATE TABLE IF NOT EXISTS WAS.WAS_REPORT_EXPORT
(
    `HASH`          varchar(64) NOT NULL,
    `REPORT_ID`     varchar(50) NOT NULL,
    `EDIT_DATE`     text        NULL,

    PRIMARY KEY (`HASH`),
    CONSTRAINT `WAS_REPORT_EXPORT_ibfk_1` FOREIGN KEY (`REPORT_ID`) REFERENCES WAS.`WAS_REPORT` (`ID`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8;

CREATE INDEX IF NOT EXISTS REPORT_ID
    on WAS.WAS_REPORT_EXPORT (REPORT_ID)
;

-- 보고서 카테고리
CREATE TABLE IF NOT EXISTS WAS.WAS_REPORT_CATEGORY (
    `ID`            varchar(50) NOT NULL,
    `NAME`          text        DEFAULT NULL,
    `SEQ`           text        DEFAULT NULL,
    `TYPE`          text        DEFAULT NULL,

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

-- 보고서 템플릿
CREATE TABLE WAS.WAS_REPORT_TEMPLATE (
    `ID`            varchar(50) NOT NULL,
    `NAME`          text        DEFAULT NULL,
    `CATEGORY_ID`   varchar(50) DEFAULT NULL,
    `USER_ID`       varchar(50) DEFAULT NULL,
    `EDIT_DATE`     datetime    DEFAULT NULL,
    `REPORT_ETC`    mediumtext  DEFAULT NULL,
    `COUNT`         int(11)     DEFAULT NULL,
    `THUMBNAIL`     mediumblob  DEFAULT NULL,

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

-- 보고서 템플릿: Image 객체 데이터
CREATE TABLE WAS.WAS_REPORT_TEMPLATE_IMAGE (
    `TEMPLATE_ID`   varchar(50) NOT NULL,
    `IMAGE_ID`      varchar(80) NOT NULL,
    `IMAGE_BASE64`  mediumtext  NOT NULL,
    `EDIT_DATE`     datetime    NOT NULL
) DEFAULT CHARSET=utf8;

/**
*   IRIS-Web-Platform
*/

-- 메뉴
CREATE TABLE IF NOT EXISTS WAS.WAS_WEB_MENU (
    `ID`            varchar(50) NOT NULL,
    `PARENT`        text        DEFAULT NULL,
    `DEPTH`         text        DEFAULT NULL,
    `SEQ`           text        DEFAULT NULL,
    `VISIBLE`       text        DEFAULT NULL,
    `SERVICE_TYPE`  text        DEFAULT NULL,
    `SERVICE_ID`    text        DEFAULT NULL,
    `SERVICE_ROUTE` text        DEFAULT NULL,
    `SERVICE_URL`   text        DEFAULT NULL,
    `FIRST_PAGE`    text        DEFAULT NULL,
    `ICON`          text        DEFAULT NULL,

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

-- 메뉴: 지역화
CREATE TABLE IF NOT EXISTS WAS.WAS_WEB_MENU_LOCALIZATION (
    `MENU_ID`       varchar(50) NOT NULL,
    `LOCALE`        text        DEFAULT NULL,
    `NAME`          text        DEFAULT NULL,
    `TYPE`          text        DEFAULT NULL
) DEFAULT CHARSET=utf8;

-- 메뉴 그룹
CREATE TABLE IF NOT EXISTS WAS.WAS_WEB_MENU_GROUP (
    `ID`            varchar(50) NOT NULL,
    `ICON`          text        DEFAULT NULL,
    `TYPE`          text        DEFAULT NULL,
    `LOGO`          text        DEFAULT NULL,
    `SEQ`           text        DEFAULT NULL,
    `FIRST_PAGE`    text        DEFAULT NULL,
    `VISIBLE`       text        DEFAULT NULL,
    `SERVICE_TYPE`  text        DEFAULT NULL,
    `FIRST_GROUP`   text        DEFAULT NULL,
    `URL`           text        DEFAULT NULL,
    `BREADCRUMB`    text        DEFAULT 'true',

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

--
CREATE TABLE IF NOT EXISTS WAS.WAS_WEB_MENU_SUB (
    `MENU_TYPE`     text        DEFAULT NULL,
    `MENU_ID`       varchar(50) NOT NULL,

    PRIMARY KEY (`MENU_ID`)
) DEFAULT CHARSET=utf8;

-- 개인 설정
CREATE TABLE IF NOT EXISTS WAS.WAS_IWP_USER_SETTING (
    `USER_ID`           varchar(50) NOT NULL,
    `FIRST_PAGE`        text        DEFAULT NULL,
    `DECIMAL_POINT`     text        NOT NULL DEFAULT '2',
    `THOUSAND_UNITS`    text        NOT NULL DEFAULT 'true',
    `MINI_HELP`         text        NOT NULL DEFAULT 'true',

    PRIMARY KEY (`USER_ID`)
) DEFAULT CHARSET=utf8;

--
CREATE TABLE IF NOT EXISTS WAS.WAS_IWP_IMAGE (
    `IMAGE_ID`      varchar(80) NOT NULL,
    `TYPE`          text        NOT NULL,
    `IMAGE_BASE64`  mediumtext  DEFAULT NULL,
    `EDIT_DATE`     text        NOT NULL,

    PRIMARY KEY (`IMAGE_ID`)
) DEFAULT CHARSET=utf8;

--
CREATE TABLE IF NOT EXISTS WAS.WAS_IWP_PROPERTY (
    `NAME`          varchar(50) NOT NULL,
    `TYPE`          varchar(50) NOT NULL,
    `VALUE`         text        DEFAULT NULL,
    PRIMARY KEY (`NAME`, `TYPE`)
) DEFAULT CHARSET=utf8;

--
CREATE TABLE IF NOT EXISTS WAS.WAS_IWP_STYLE (
    `KEY`           text        NOT NULL,
    `PROPERTY`      text        NOT NULL,
    `VALUE`         text        DEFAULT NULL
) DEFAULT CHARSET=utf8;

-- 환경 설정
CREATE TABLE IF NOT EXISTS WAS.WAS_IWP_CONFIG_VALUE (
    `KEY`           varchar(100) NOT NULL,
    `DEFAULT_VALUE` text        DEFAULT NULL,
    `VALUE`         text        DEFAULT NULL,

    PRIMARY KEY (`KEY`)
) DEFAULT CHARSET=utf8;

--
CREATE TABLE IF NOT EXISTS WAS.WAS_IWP_CONFIG_SETTING (
    `ID`            int(11)      NOT NULL AUTO_INCREMENT,
    `KEY`           varchar(100) NOT NULL,
    `CATEGORY`      text         NOT NULL,
    `SUB_CATEGORY`  text        DEFAULT NULL,
    `FIRST_SEQ`     text        DEFAULT NULL,
    `FIRST_TYPE`    text        DEFAULT NULL,
    `FIRST_NAME`    text        DEFAULT NULL,
    `SECOND_SEQ`    text        DEFAULT NULL,
    `SECOND_NAME`   text        DEFAULT NULL,
    `TOOLTIP`       text        DEFAULT NULL,
    `THIRD_SEQ`     text        DEFAULT NULL,
    `THIRD_TYPE`    text        DEFAULT NULL,
    `THIRD_NAME`    text        DEFAULT NULL,

    PRIMARY KEY (`ID`),
    UNIQUE KEY `was_iwp_config_setting_un` (`KEY`),
    CONSTRAINT `was_iwp_config_setting_FK` FOREIGN KEY (`KEY`) REFERENCES WAS.`WAS_IWP_CONFIG_VALUE` (`KEY`) ON DELETE CASCADE ON UPDATE CASCADE
) AUTO_INCREMENT = 1
  DEFAULT CHARSET=utf8;

--
CREATE TABLE IF NOT EXISTS WAS.WAS_IWP_CONFIG_LOCALIZATION (
    `TYPE`          text        NOT NULL,
    `KEY`           varchar(50) NOT NULL,
    `LOCALE`        text        DEFAULT NULL,
    `NAME`          text        DEFAULT NULL
) DEFAULT CHARSET=utf8;

--
CREATE TABLE IF NOT EXISTS WAS.WAS_LOGIN_LOCK (
    `ID`            varchar(50) NOT NULL,
    `FAIL_COUNT`    int(11)     DEFAULT 0,
    `FAIL_TIME`     datetime    DEFAULT NULL,

    PRIMARY KEY (`ID`)
) DEFAULT CHARSET=utf8;

/**
*   IRIS-Map-Analyzer
*/

--
CREATE TABLE IF NOT EXISTS WAS.`WAS_COMMON_CODE` (
    `TYPE`          varchar(50) DEFAULT NULL,
    `VALUE`         varchar(50) DEFAULT NULL,
    `NAME`          varchar(50) DEFAULT NULL
) DEFAULT CHARSET=utf8
comment '공통 코드 테이블';

--
CREATE TABLE IF NOT EXISTS WAS.`WAS_MAP_PROJECT` (
    `PROJECT_ID`    varchar(50) NOT NULL,
    `USER_ID`       varchar(50) NOT NULL,
    `PROJECT_NAME`  varchar(50) NOT NULL,
    `CREATE_DATE`   datetime    DEFAULT NULL,
    `UPDATE_DATE`   datetime    DEFAULT NULL,
    `CATEGORY_ID`   int(11)     DEFAULT NULL,
    `TEMPLATE_YN`   char(1)     DEFAULT 'N',
    `DATA`          text        DEFAULT NULL,
    `USED_COUNT`    int(11)     DEFAULT NULL,

    PRIMARY KEY (`PROJECT_ID`)
) DEFAULT CHARSET=utf8
comment 'Map 프로젝트 정보';

CREATE INDEX IF NOT EXISTS WAS_MAP_PROJECT_INDEX ON WAS.`WAS_MAP_PROJECT` (UPDATE_DATE, TEMPLATE_YN, PROJECT_ID, CATEGORY_ID, PROJECT_NAME);

--
CREATE TABLE IF NOT EXISTS WAS.`WAS_MAP_PROJECT_CATEGORY` (
    `CATEGORY_ID`   int(11)     AUTO_INCREMENT,
    `CATEGORY_NAME` varchar(50) NOT NULL,
    `ORDER_SEQ`     int(11)     DEFAULT NULL,

    PRIMARY KEY (`CATEGORY_ID`)
) DEFAULT CHARSET=utf8
comment 'Map 프로젝트 카테고리 리스트';

CREATE INDEX IF NOT EXISTS WAS_MAP_PROJECT_CATEGORY_CATEGORY_ID_INDEX ON WAS.`WAS_MAP_PROJECT_CATEGORY` (CATEGORY_ID);

--
CREATE TABLE IF NOT EXISTS WAS.`WAS_MAP_PROJECT_EXPORT` (
    `HASH`              varchar(64) NOT NULL,
    `MAP_PROJECT_ID`    varchar(50) NOT NULL,
    `UPDATE_DATE`       datetime    DEFAULT NULL,

    PRIMARY KEY (`HASH`),
    UNIQUE KEY `MAP_PROJECT_ID_2` (`MAP_PROJECT_ID`),
    KEY `MAP_PROJECT_ID` (`MAP_PROJECT_ID`),
    CONSTRAINT `WAS_MAP_PROJECT_EXPORT_ibfk_1` FOREIGN KEY (`MAP_PROJECT_ID`) REFERENCES WAS.`WAS_MAP_PROJECT` (`PROJECT_ID`) ON DELETE CASCADE
) DEFAULT CHARSET=utf8
comment 'Map 프로젝트 URL 정보';

--
CREATE TABLE IF NOT EXISTS WAS.`WAS_MAP_IMAGE` (
    `IMAGE_ID`      varchar(80) NOT NULL,
    `TYPE`          text        NOT NULL,
    `IMAGE_BASE64`  mediumtext  DEFAULT NULL,
    `EDIT_DATE`     text        NOT NULL,

    PRIMARY KEY (`IMAGE_ID`)
) DEFAULT CHARSET=utf8
comment 'Map 프로젝트 썸네일 이미지 테이블';

CREATE INDEX IF NOT EXISTS WAS_MAP_IMAGE_IMAGE_ID_INDEX ON WAS.`WAS_MAP_IMAGE` (IMAGE_ID);

--
CREATE TABLE IF NOT EXISTS WAS.`WAS_MAP_THUMBNAIL`
(
    `PROJECT_ID` varchar(50) NOT NULL,
    `THUMBNAIL`  mediumblob  NULL,
    CONSTRAINT `PRIMARY`
        PRIMARY KEY (`PROJECT_ID`),
    CONSTRAINT `WAS_MAP_THUMBNAIL_WAS_MAP_PROJECT_PROJECT_ID_FK`
        FOREIGN KEY (`PROJECT_ID`) REFERENCES WAS.`WAS_MAP_PROJECT` (`PROJECT_ID`)
) DEFAULT CHARSET=utf8
comment '프로젝트 썸네일 테이블 (New)';

--
CREATE TABLE IF NOT EXISTS WAS.`WAS_MAP_SEARCH_HISTORY` (
    `USER_ID`           varchar(50)     NOT NULL,
    `SEARCH_KEYWORD`    varchar(100)    NOT NULL,

    CONSTRAINT `WAS_MAP_SEARCH_HISTORY_PK` PRIMARY KEY (`USER_ID`, `SEARCH_KEYWORD`)
) DEFAULT CHARSET=utf8
comment '주소 검색 히스토리';

--
CREATE TABLE IF NOT EXISTS WAS.`WAS_MAP_QUERY_HISTORY` (
    `USER_ID`     varchar(50) NOT NULL,
    `MODEL_ID`    varchar(50) not null,
    `QUERY`       text        NULL,
    `CREATE_DATE` datetime    NOT NULL
) DEFAULT CHARSET=utf8
comment 'DSL 쿼리 검색 히스토리 (데이터모델/스냅샷)';

CREATE INDEX IF NOT EXISTS WAS_MAP_QUERY_HISTORY_CREATE_DATE_USER_ID_INDEX ON WAS.`WAS_MAP_QUERY_HISTORY` (CREATE_DATE, USER_ID);

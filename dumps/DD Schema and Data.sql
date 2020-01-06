--
-- File generated with SQLiteStudio v3.2.1 on Mon Jan 6 03:47:33 2020
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Collection
DROP TABLE IF EXISTS Collection;

CREATE TABLE Collection (
    CollectionTagId INTEGER CONSTRAINT NN_Collection_CollectionTagId NOT NULL
                            CONSTRAINT FK_Collection_CollectionTagId_Tag_Id REFERENCES Tag (Id) ON DELETE CASCADE
                                                                                                ON UPDATE CASCADE,
    GalleryId       INTEGER CONSTRAINT NN_Collection_GalleryId NOT NULL
                            CONSTRAINT FK_Collection_GalleryId_Gallery_Id REFERENCES Gallery (Id) ON DELETE CASCADE
                                                                                                  ON UPDATE CASCADE,
    [Order]         INTEGER,
    CONSTRAINT PK_Collection_CollectionTagId_GalleryId PRIMARY KEY (
        CollectionTagId,
        GalleryId
    ),
    CONSTRAINT UQ_Collection_CollectionTagId_GalleryId UNIQUE (
        CollectionTagId,
        GalleryId
    )
);


-- Table: FavoriteGallery
DROP TABLE IF EXISTS FavoriteGallery;

CREATE TABLE FavoriteGallery (
    GalleryId         INTEGER CONSTRAINT FK_FavoriteGallery_GalleryId_Gallery_Id REFERENCES Gallery (Id) ON DELETE CASCADE
                                                                                                         ON UPDATE CASCADE
                              CONSTRAINT UQ_FavoriteGallery_GalleryId UNIQUE
                              CONSTRAINT NN_FavoriteGallery_GalleryId NOT NULL
                              CONSTRAINT PK_FavoriteGallery_GalleryId PRIMARY KEY,
    DateTimeFavorited INTEGER
);


-- Table: FavoriteTag
DROP TABLE IF EXISTS FavoriteTag;

CREATE TABLE FavoriteTag (
    TagId             INTEGER CONSTRAINT FK_FavoriteTag_TagId_Tag_Id REFERENCES Tag (Id) ON DELETE CASCADE
                                                                                         ON UPDATE CASCADE
                              CONSTRAINT UQ_FavoriteTag_TagId UNIQUE
                              CONSTRAINT NN_FavoriteTag_TagId NOT NULL
                              CONSTRAINT PK_FavoriteTag_TagId PRIMARY KEY,
    DateTimeFavorited INTEGER
);


-- Table: Gallery
DROP TABLE IF EXISTS Gallery;

CREATE TABLE Gallery (
    Id                 INTEGER    CONSTRAINT PK_Gallery_Id PRIMARY KEY AUTOINCREMENT
                                  CONSTRAINT UQ_Gallery_Id UNIQUE
                                  CONSTRAINT NN_Gallery_Id NOT NULL,
    Name               TEXT (300) CONSTRAINT CK_Gallery_Name_MaxLength_300 CHECK (length(Name) <= 300),
    NameCultureInfo    TEXT (17)  CONSTRAINT CK_Gallery_NameCultureInfo_MaxLength_17 CHECK (length(NameCultureInfo) <= 17),
    Description        TEXT (500) CONSTRAINT CK_Gallery_Description_MaxLegnth_500 CHECK (length(Description) <= 500),
    GalleryTypeId      INTEGER    CONSTRAINT NN_Gallery_GalleryTypeId NOT NULL
                                  CONSTRAINT FK_Gallery_GalleryTypeId REFERENCES GalleryType (Id) ON DELETE RESTRICT
                                                                                                  ON UPDATE CASCADE,
    ResourceFileId     INTEGER    CONSTRAINT NN_Gallery_ResourceFileId NOT NULL
                                  CONSTRAINT FK_Gallery_ResourceFileId REFERENCES ResourceFile (Id) ON DELETE RESTRICT
                                                                                                    ON UPDATE CASCADE
                                  CONSTRAINT UQ_Gallery_ResourceFileId UNIQUE,
    Length             INTEGER,
    Rating             INTEGER,
    DateTimeRated      INTEGER,
    DateTimeLastEdited INTEGER,
    DateTimeLastTagged INTEGER
);


-- Table: GalleryAlias
DROP TABLE IF EXISTS GalleryAlias;

CREATE TABLE GalleryAlias (
    Id              INTEGER    CONSTRAINT PK_GalleryAlias_Id PRIMARY KEY AUTOINCREMENT
                               CONSTRAINT UQ_GalleryAlias_Id UNIQUE
                               CONSTRAINT NN_GalleryAlias_Id NOT NULL,
    GalleryId       INTEGER    CONSTRAINT FK_GalleryAlias_GalleryId REFERENCES Gallery (Id) ON DELETE CASCADE
                                                                                            ON UPDATE CASCADE
                               CONSTRAINT NN_GalleryAlias_GalleryId NOT NULL,
    Name            TEXT (300) CONSTRAINT NN_GalleryAlias_Name NOT NULL
                               CONSTRAINT CK_GalleryAlias_Name_MaxLength_300 CHECK (length(Name) <= 300),
    NameCultureInfo TEXT (17)  CONSTRAINT CK_GalleryAlias_Name_MaxLength_17 CHECK (length(NameCultureInfo) <= 17) 
);


-- Table: GalleryRelation
DROP TABLE IF EXISTS GalleryRelation;

CREATE TABLE GalleryRelation (
    FromGalleryId INTEGER CONSTRAINT NN_GalleryRelation_FromTagId NOT NULL
                          CONSTRAINT FK_GalleryRelation_FromTagId_Gallery_Id REFERENCES Gallery (Id) ON DELETE CASCADE
                                                                                                     ON UPDATE CASCADE,
    ToGalleryId   INTEGER CONSTRAINT NN_GalleryRelation_ToTagId NOT NULL
                          CONSTRAINT FK_GalleryRelation_ToTagId REFERENCES Gallery (Id),
    CONSTRAINT UQ_GalleryRelation_FromTagGalleryId_ToGalleryId UNIQUE (
        FromGalleryId,
        ToGalleryId
    ),
    CONSTRAINT FK_GalleryRelation_FromGalleryId_ToGalleryId PRIMARY KEY (
        FromGalleryId,
        ToGalleryId
    )
);


-- Table: GalleryTag
DROP TABLE IF EXISTS GalleryTag;

CREATE TABLE GalleryTag (
    GalleryId  INTEGER CONSTRAINT NN_GalleryTag_GalleryId NOT NULL,
    TagId      INTEGER CONSTRAINT NN_GalleryTag_TagId NOT NULL,
    TagGroupId INTEGER CONSTRAINT FK_GalleryTag_TagGroupId REFERENCES TagGroup (Id) ON DELETE SET NULL
                                                                                    ON UPDATE CASCADE,
    CONSTRAINT PK_GalleryTag_GalleryId_TagId PRIMARY KEY (
        GalleryId,
        TagId
    ),
    CONSTRAINT UQ_GalleryTag_GalleryId_TagId UNIQUE (
        GalleryId,
        TagId
    )
);


-- Table: GalleryType
DROP TABLE IF EXISTS GalleryType;

CREATE TABLE GalleryType (
    Id   INTEGER   CONSTRAINT PK_GalleryType_Id PRIMARY KEY AUTOINCREMENT
                   CONSTRAINT UQ_GalleryType_Id UNIQUE
                   CONSTRAINT NN_GalleryType_Id NOT NULL,
    Name TEXT (17) CONSTRAINT UQ_GalleryType_Name UNIQUE
                   CONSTRAINT CK_GalleryType_Name_MaxLength_17 CHECK (length(Name) <= 17) 
);


-- Table: ResourceFile
DROP TABLE IF EXISTS ResourceFile;

CREATE TABLE ResourceFile (
    Id           INTEGER    CONSTRAINT PK_ResourceFile_Id PRIMARY KEY AUTOINCREMENT
                            CONSTRAINT UQ_ResourceFile_Id UNIQUE
                            CONSTRAINT NN_ResourceFile_Id NOT NULL,
    RelativePath TEXT (260) CONSTRAINT UQ_ResourceFile_RelativePath UNIQUE
                            CONSTRAINT NN_ResourceFile_RelativePath NOT NULL
                            CONSTRAINT CK_ResourceFile_RelativePath_MaxLength_260 CHECK (length(RelativePath) <= 260),
    Hash         INTEGER    CONSTRAINT NN_ResourceFile_Hash NOT NULL,
    SourceInfoId INTEGER    CONSTRAINT FK_ResourceFile_SourceInfoId_SourceInfo_Id REFERENCES SourceInfo (Id) ON DELETE SET NULL
                                                                                                             ON UPDATE CASCADE
                            CONSTRAINT UQ_ResourceFile_SourceInfoId UNIQUE
);


-- Table: SourceGroup
DROP TABLE IF EXISTS SourceGroup;

CREATE TABLE SourceGroup (
    Id          INTEGER     CONSTRAINT PK_SourceGroup_Id PRIMARY KEY AUTOINCREMENT
                            CONSTRAINT UQ_SourceGroup_Id UNIQUE
                            CONSTRAINT NN_SourceGroup_Id NOT NULL,
    Name        TEXT (100)  CONSTRAINT UQ_SourceGroup_Name UNIQUE
                            CONSTRAINT NN_SourceGroup_Name NOT NULL
                            CONSTRAINT CK_SourceGroup_Name_MaxLength_100 CHECK (length(Name) <= 100),
    Url         TEXT (2048) CONSTRAINT CK_SourceGroup_Url_MaxLength_2048 CHECK (length(Url) <= 2048),
    Description TEXT (8000) CONSTRAINT CK_SourceGroup_Descriptions_MaxLength_8000 CHECK (length(Description) <= 8000),
    TagId       INTEGER     CONSTRAINT FK_SourceGroup_TagId_Tag_Id REFERENCES Tag (Id) ON DELETE SET NULL
                                                                                       ON UPDATE CASCADE
);


-- Table: SourceInfo
DROP TABLE IF EXISTS SourceInfo;

CREATE TABLE SourceInfo (
    Id                   INTEGER     CONSTRAINT PK_SourceInfo_Id PRIMARY KEY AUTOINCREMENT
                                     CONSTRAINT UQ_SourceInfo_Id UNIQUE
                                     CONSTRAINT NN_SourceInfo_Id NOT NULL,
    DateTimeCreated      INTEGER,
    DateTimePosted       INTEGER,
    DateTimeConverted    INTEGER,
    DateTimeAdded        INTEGER,
    DateTimeLastEdited   INTEGER,
    Url                  TEXT (2048) CONSTRAINT CK_SourceInfo_Url_MaxLength_2048 CHECK (length(Url) <= 2048),
    CustomInfo           TEXT (8000) CONSTRAINT CK_SourceInfo_CustomInfo_MaxLength_8000 CHECK (length(CustomInfo) <= 8000),
    PosterSourceGroupId  INTEGER     CONSTRAINT FK_SourceInfo_PosterSourceGroupId_SourceGroup_Id REFERENCES SourceGroup (Id) ON DELETE SET NULL
                                                                                                                             ON UPDATE CASCADE,
    CreatorSourceGroupId INTEGER     CONSTRAINT FK_SourceInfo_CreatorSourceGroupId_SourceGroup_Id REFERENCES Tag (Id) ON DELETE SET NULL
                                                                                                                      ON UPDATE CASCADE,
    HostSourceGroupId    INTEGER     CONSTRAINT FK_SourceInfo_HostSourceGroupId_SourceGroup_Id REFERENCES SourceGroup (Id) ON DELETE SET NULL
                                                                                                                           ON UPDATE CASCADE
);


-- Table: Tag
DROP TABLE IF EXISTS Tag;

CREATE TABLE Tag (
    Id               INTEGER    CONSTRAINT PK_Tag_Id PRIMARY KEY AUTOINCREMENT
                                CONSTRAINT UQ_Tag_Id UNIQUE
                                CONSTRAINT NN_Tag_Id NOT NULL,
    Name             TEXT (100) CONSTRAINT NN_Tag_Name NOT NULL
                                CONSTRAINT CK_Tag_Name_MaxLength_100 CHECK (length(Name) <= 100),
    NameCultureInfo  TEXT (17)  CONSTRAINT CK_Tag_NameCultureInfo_MaxLength_17 CHECK (length(NameCultureInfo) <= 17),
    TagTypeId        INTEGER    CONSTRAINT FK_Tag_TagTypeId_TagType_Id REFERENCES TagType (Id) ON DELETE RESTRICT
                                                                                               ON UPDATE CASCADE
                                CONSTRAINT NN_Tag_TagTypeId NOT NULL,
    Description      TEXT (500) CONSTRAINT CK_Tag_TagTypeId_MaxLength_500 CHECK (length(Description) <= 500),
    ShortDescription TEXT (100) CONSTRAINT CK_Tag_TagTypeId_MaxLength_100 CHECK (length(ShortDescription) <= 100),
    ResourceFileId   INTEGER    CONSTRAINT FK_Tag_ResourceFileId_ResourceFile_Id REFERENCES ResourceFile (Id) ON DELETE SET NULL
                                                                                                              ON UPDATE CASCADE
                                CONSTRAINT UQ_Tag_ResourceFileId UNIQUE,
    Rating           INTEGER,
    CONSTRAINT UQ_Tag_Name_TagTypeId UNIQUE (
        Name,
        TagTypeId
    )
);


-- Table: TagAlias
DROP TABLE IF EXISTS TagAlias;

CREATE TABLE TagAlias (
    Id              INTEGER    CONSTRAINT PK_TagAlias_Id PRIMARY KEY AUTOINCREMENT
                               CONSTRAINT UQ_TagAlias_Id UNIQUE
                               CONSTRAINT NN_TagAlias_Id NOT NULL,
    TagId           INTEGER    CONSTRAINT FK_TagAlias_TagId_Tag_Id REFERENCES Tag (Id) ON DELETE CASCADE
                                                                                       ON UPDATE CASCADE
                               CONSTRAINT NN_TagAlias_TagId NOT NULL,
    Name            TEXT (100) CONSTRAINT NN_TagAlias_Name NOT NULL
                               CONSTRAINT CK_TagAlias_Name_MaxLength_100 CHECK (length(Name) <= 100),
    NameCultureInfo TEXT (17)  CONSTRAINT CK_TagAlias_Name_MaxLength_17 CHECK (length(NameCultureInfo) <= 17) 
);


-- Table: TagGroup
DROP TABLE IF EXISTS TagGroup;

CREATE TABLE TagGroup (
    Id        INTEGER   CONSTRAINT PK_TagGroup_Id PRIMARY KEY AUTOINCREMENT
                        CONSTRAINT UQ_TagGroup_Id UNIQUE
                        CONSTRAINT NN_TagGroup_Id NOT NULL,
    Name      TEXT (30) CONSTRAINT UQ_TagGroup_Name UNIQUE
                        CONSTRAINT NN_TagGroup_Name NOT NULL
                        CONSTRAINT CK_TagGroup_Name_MaxLength_30 CHECK (length(Name) <= 30),
    TagTypeId INTEGER   CONSTRAINT NN_TagGroup_TagTypeId NOT NULL
                        CONSTRAINT FK_TagGroup_TagTypeId_TagType_Id REFERENCES TagType (Id) ON DELETE RESTRICT
                                                                                            ON UPDATE CASCADE
);


-- Table: TagRelation
DROP TABLE IF EXISTS TagRelation;

CREATE TABLE TagRelation (
    FromTagId INTEGER CONSTRAINT NN_TagRelation_FromTagId NOT NULL
                      CONSTRAINT FK_TagRelation_FromTagId_Tag_Id REFERENCES Tag (Id) ON DELETE CASCADE
                                                                                     ON UPDATE CASCADE,
    ToTagId   INTEGER CONSTRAINT FK_TagRelation_ToTagId_Tag_Id REFERENCES Tag (Id) ON DELETE CASCADE
                                                                                   ON UPDATE CASCADE
                      CONSTRAINT NN_TagRelation_ToTagId NOT NULL,
    CONSTRAINT UQ_TagRelation_FromTagId_ToTagId UNIQUE (
        FromTagId,
        ToTagId
    ),
    CONSTRAINT FK_TagRelation_FromTagId_ToTagId PRIMARY KEY (
        FromTagId,
        ToTagId
    )
);


-- Table: TagType
DROP TABLE IF EXISTS TagType;

CREATE TABLE TagType (
    Id   INTEGER   CONSTRAINT PK_TagType_Id PRIMARY KEY AUTOINCREMENT
                   CONSTRAINT UQ_TagType_Id UNIQUE
                   CONSTRAINT NN_TagType_Id NOT NULL,
    Name TEXT (30) CONSTRAINT NN_TagType_Name NOT NULL
                   CONSTRAINT CK_TagType_Name_MaxLength_30 CHECK (length(Name) <= 30) 
                   CONSTRAINT UQ_TagType_Name UNIQUE
);


-- Index: IX_UQ_CO_FavoriteGallery_DateTimeFavorited_GalleryId
DROP INDEX IF EXISTS IX_UQ_CO_FavoriteGallery_DateTimeFavorited_GalleryId;

CREATE UNIQUE INDEX IX_UQ_CO_FavoriteGallery_DateTimeFavorited_GalleryId ON FavoriteGallery (
    DateTimeFavorited,
    GalleryId
);


-- Index: IX_UQ_CO_FavoriteTag_DateTimeFavorited_TagId
DROP INDEX IF EXISTS IX_UQ_CO_FavoriteTag_DateTimeFavorited_TagId;

CREATE UNIQUE INDEX IX_UQ_CO_FavoriteTag_DateTimeFavorited_TagId ON FavoriteTag (
    DateTimeFavorited,
    TagId
);


-- Index: IX_UQ_CO_GalleryRelation_FromGalleryId_ToGalleryId
DROP INDEX IF EXISTS IX_UQ_CO_GalleryRelation_FromGalleryId_ToGalleryId;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryRelation_FromGalleryId_ToGalleryId ON GalleryRelation (
    FromGalleryId,
    ToGalleryId
);


-- Index: IX_UQ_CO_GalleryRelation_ToGalleryId_FromGalleryId
DROP INDEX IF EXISTS IX_UQ_CO_GalleryRelation_ToGalleryId_FromGalleryId;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryRelation_ToGalleryId_FromGalleryId ON GalleryRelation (
    ToGalleryId,
    FromGalleryId
);


-- Index: IX_UQ_CO_GalleryTag_GalleryId_TagGroupId_TagId
DROP INDEX IF EXISTS IX_UQ_CO_GalleryTag_GalleryId_TagGroupId_TagId;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryTag_GalleryId_TagGroupId_TagId ON GalleryTag (
    GalleryId,
    TagGroupId,
    TagId
);


-- Index: IX_UQ_CO_GalleryTag_TagId_GalleryId
DROP INDEX IF EXISTS IX_UQ_CO_GalleryTag_TagId_GalleryId;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryTag_TagId_GalleryId ON GalleryTag (
    TagId,
    GalleryId
);


-- Index: IX_UQ_CO_GalleryType_Id_Name
DROP INDEX IF EXISTS IX_UQ_CO_GalleryType_Id_Name;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryType_Id_Name ON GalleryType (
    Id,
    Name
);


-- Index: IX_UQ_CO_SourceInfo_DateTimeAdded_Id
DROP INDEX IF EXISTS IX_UQ_CO_SourceInfo_DateTimeAdded_Id;

CREATE UNIQUE INDEX IX_UQ_CO_SourceInfo_DateTimeAdded_Id ON SourceInfo (
    DateTimeAdded,
    Id
);


-- Index: IX_UQ_CO_SourceInfo_DateTImeConverted_Id
DROP INDEX IF EXISTS IX_UQ_CO_SourceInfo_DateTImeConverted_Id;

CREATE UNIQUE INDEX IX_UQ_CO_SourceInfo_DateTImeConverted_Id ON SourceInfo (
    DateTimeConverted,
    Id
);


-- Index: IX_UQ_CO_SourceInfo_DateTimeCreated_Id
DROP INDEX IF EXISTS IX_UQ_CO_SourceInfo_DateTimeCreated_Id;

CREATE UNIQUE INDEX IX_UQ_CO_SourceInfo_DateTimeCreated_Id ON SourceInfo (
    DateTimeCreated,
    Id
);


-- Index: IX_UQ_CO_SourceInfo_DateTimePosted_Id
DROP INDEX IF EXISTS IX_UQ_CO_SourceInfo_DateTimePosted_Id;

CREATE UNIQUE INDEX IX_UQ_CO_SourceInfo_DateTimePosted_Id ON SourceInfo (
    DateTimePosted,
    Id
);


-- Index: IX_UQ_CO_Tag_Name_TagTypeId_Id
DROP INDEX IF EXISTS IX_UQ_CO_Tag_Name_TagTypeId_Id;

CREATE UNIQUE INDEX IX_UQ_CO_Tag_Name_TagTypeId_Id ON Tag (
    Name,
    TagTypeId,
    Id
);


-- Index: IX_UQ_CO_TagGroup_Name_Id
DROP INDEX IF EXISTS IX_UQ_CO_TagGroup_Name_Id;

CREATE UNIQUE INDEX IX_UQ_CO_TagGroup_Name_Id ON TagGroup (
    Name,
    Id
);


-- Index: IX_UQ_CO_TagGroup_TagTypeId_Id
DROP INDEX IF EXISTS IX_UQ_CO_TagGroup_TagTypeId_Id;

CREATE UNIQUE INDEX IX_UQ_CO_TagGroup_TagTypeId_Id ON TagGroup (
    TagTypeId,
    Id
);


-- Index: IX_UQ_CO_TagRelation_FromTagId_ToTagId
DROP INDEX IF EXISTS IX_UQ_CO_TagRelation_FromTagId_ToTagId;

CREATE UNIQUE INDEX IX_UQ_CO_TagRelation_FromTagId_ToTagId ON TagRelation (
    FromTagId,
    ToTagId
);


-- Index: IX_UQ_CO_TagRelation_ToTagId_FromTagId
DROP INDEX IF EXISTS IX_UQ_CO_TagRelation_ToTagId_FromTagId;

CREATE UNIQUE INDEX IX_UQ_CO_TagRelation_ToTagId_FromTagId ON TagRelation (
    ToTagId,
    FromTagId
);


-- Index: IX_UQ_CO_TagType_Id_Name
DROP INDEX IF EXISTS IX_UQ_CO_TagType_Id_Name;

CREATE UNIQUE INDEX IX_UQ_CO_TagType_Id_Name ON TagType (
    Id,
    Name
);


-- Index: IX_UQ_CO_TagType_Name_Id
DROP INDEX IF EXISTS IX_UQ_CO_TagType_Name_Id;

CREATE UNIQUE INDEX IX_UQ_CO_TagType_Name_Id ON TagType (
    Name,
    Id
);


-- Index: IX_UQ_Collection_CollectionTagId_GalleryId
DROP INDEX IF EXISTS IX_UQ_Collection_CollectionTagId_GalleryId;

CREATE UNIQUE INDEX IX_UQ_Collection_CollectionTagId_GalleryId ON Collection (
    CollectionTagId,
    GalleryId
);


-- Index: IX_UQ_FavoriteGallery_GalleryId
DROP INDEX IF EXISTS IX_UQ_FavoriteGallery_GalleryId;

CREATE UNIQUE INDEX IX_UQ_FavoriteGallery_GalleryId ON FavoriteGallery (
    GalleryId
);


-- Index: IX_UQ_FavoriteTag_TagId
DROP INDEX IF EXISTS IX_UQ_FavoriteTag_TagId;

CREATE UNIQUE INDEX IX_UQ_FavoriteTag_TagId ON FavoriteTag (
    TagId
);


-- Index: IX_UQ_Gallery_GalleryTypeId_Id
DROP INDEX IF EXISTS IX_UQ_Gallery_GalleryTypeId_Id;

CREATE UNIQUE INDEX IX_UQ_Gallery_GalleryTypeId_Id ON Gallery (
    GalleryTypeId,
    Id
);


-- Index: IX_UQ_Gallery_Id
DROP INDEX IF EXISTS IX_UQ_Gallery_Id;

CREATE UNIQUE INDEX IX_UQ_Gallery_Id ON Gallery (
    Id
);


-- Index: IX_UQ_Gallery_Rating_Id
DROP INDEX IF EXISTS IX_UQ_Gallery_Rating_Id;

CREATE UNIQUE INDEX IX_UQ_Gallery_Rating_Id ON Gallery (
    Rating,
    Id
);


-- Index: IX_UQ_GalleryAlias_GalleryId_Id
DROP INDEX IF EXISTS IX_UQ_GalleryAlias_GalleryId_Id;

CREATE UNIQUE INDEX IX_UQ_GalleryAlias_GalleryId_Id ON GalleryAlias (
    GalleryId,
    Id
);


-- Index: IX_UQ_GalleryAlias_Id
DROP INDEX IF EXISTS IX_UQ_GalleryAlias_Id;

CREATE UNIQUE INDEX IX_UQ_GalleryAlias_Id ON GalleryAlias (
    Id
);


-- Index: IX_UQ_ResourceFile_Id
DROP INDEX IF EXISTS IX_UQ_ResourceFile_Id;

CREATE UNIQUE INDEX IX_UQ_ResourceFile_Id ON ResourceFile (
    Id
);


-- Index: IX_UQ_ResourceFile_SourceInfoId
DROP INDEX IF EXISTS IX_UQ_ResourceFile_SourceInfoId;

CREATE UNIQUE INDEX IX_UQ_ResourceFile_SourceInfoId ON ResourceFile (
    SourceInfoId
);


-- Index: IX_UQ_SourceGroup_Id
DROP INDEX IF EXISTS IX_UQ_SourceGroup_Id;

CREATE UNIQUE INDEX IX_UQ_SourceGroup_Id ON SourceGroup (
    Id
);


-- Index: IX_UQ_SourceInfo_Id
DROP INDEX IF EXISTS IX_UQ_SourceInfo_Id;

CREATE UNIQUE INDEX IX_UQ_SourceInfo_Id ON SourceInfo (
    Id
);


-- Index: IX_UQ_Tag_Id
DROP INDEX IF EXISTS IX_UQ_Tag_Id;

CREATE UNIQUE INDEX IX_UQ_Tag_Id ON Tag (
    Id
);


-- Index: IX_UQ_Tag_TagTypeId_Id
DROP INDEX IF EXISTS IX_UQ_Tag_TagTypeId_Id;

CREATE UNIQUE INDEX IX_UQ_Tag_TagTypeId_Id ON Tag (
    TagTypeId,
    Id
);


-- Index: IX_UQ_TagAlias_Id
DROP INDEX IF EXISTS IX_UQ_TagAlias_Id;

CREATE UNIQUE INDEX IX_UQ_TagAlias_Id ON TagAlias (
    Id
);


-- Index: IX_UQ_TagAlias_TagId_Id
DROP INDEX IF EXISTS IX_UQ_TagAlias_TagId_Id;

CREATE UNIQUE INDEX IX_UQ_TagAlias_TagId_Id ON TagAlias (
    TagId,
    Id
);


-- Index: IX_UQ_TagGroup_Id
DROP INDEX IF EXISTS IX_UQ_TagGroup_Id;

CREATE UNIQUE INDEX IX_UQ_TagGroup_Id ON TagGroup (
    Id
);


-- Trigger: TR_FavoriteGallery_AI_Log_DateTimeFavorited
DROP TRIGGER IF EXISTS TR_FavoriteGallery_AI_Log_DateTimeFavorited;
CREATE TRIGGER TR_FavoriteGallery_AI_Log_DateTimeFavorited
         AFTER INSERT
            ON FavoriteGallery
      FOR EACH ROW
BEGIN
    UPDATE FavoriteGallery
       SET DateTimeFavorited = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_FavoriteGallery_AU_Log_DateTimeFavorited
DROP TRIGGER IF EXISTS TR_FavoriteGallery_AU_Log_DateTimeFavorited;
CREATE TRIGGER TR_FavoriteGallery_AU_Log_DateTimeFavorited
         AFTER UPDATE
            ON FavoriteGallery
      FOR EACH ROW
          WHEN NEW.GalleryId IS NOT OLD.GalleryId
BEGIN
    UPDATE FavoriteGallery
       SET DateTimeFavorited = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_FavoriteTag_AI_Log_DateTimeFavorited
DROP TRIGGER IF EXISTS TR_FavoriteTag_AI_Log_DateTimeFavorited;
CREATE TRIGGER TR_FavoriteTag_AI_Log_DateTimeFavorited
         AFTER INSERT
            ON FavoriteTag
      FOR EACH ROW
BEGIN
    UPDATE FavoriteTag
       SET DateTimeFavorited = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_FavoriteTag_AU_Log_DateTimeFavorited
DROP TRIGGER IF EXISTS TR_FavoriteTag_AU_Log_DateTimeFavorited;
CREATE TRIGGER TR_FavoriteTag_AU_Log_DateTimeFavorited
         AFTER UPDATE
            ON FavoriteTag
      FOR EACH ROW
          WHEN NEW.TagId IS NOT OLD.TagId
BEGIN
    UPDATE FavoriteTag
       SET DateTimeFavorited = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_Gallery_AI_Log_DateTimeRated
DROP TRIGGER IF EXISTS TR_Gallery_AI_Log_DateTimeRated;
CREATE TRIGGER TR_Gallery_AI_Log_DateTimeRated
         AFTER INSERT
            ON Gallery
      FOR EACH ROW
          WHEN NEW.Rating IS NOT NULL
BEGIN
    UPDATE Gallery
       SET DateTimeRated = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_Gallery_AU_ClearLog_DateTimeRatedOnNullRating
DROP TRIGGER IF EXISTS TR_Gallery_AU_ClearLog_DateTimeRatedOnNullRating;
CREATE TRIGGER TR_Gallery_AU_ClearLog_DateTimeRatedOnNullRating
         AFTER UPDATE
            ON Gallery
      FOR EACH ROW
          WHEN (NEW.Rating IS NULL) AND 
               (NEW.Rating IS NOT OLD.Rating) 
BEGIN
    UPDATE Gallery
       SET DateTimeRated = NULL
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_Gallery_AU_Log_DateTimeLastEdited
DROP TRIGGER IF EXISTS TR_Gallery_AU_Log_DateTimeLastEdited;
CREATE TRIGGER TR_Gallery_AU_Log_DateTimeLastEdited
         AFTER UPDATE
            ON Gallery
      FOR EACH ROW
          WHEN (OLD.Name IS NOT NEW.Name) OR 
               (OLD.NameCultureInfo IS NOT NEW.NameCultureInfo) OR 
               (OLD.Description IS NOT NEW.Description) OR 
               (OLD.GalleryTypeId IS NOT NEW.GalleryTypeId) OR 
               (OLD.ResourceFileId IS NOT NEW.ResourceFileId) OR 
               (OLD.Length IS NOT NEW.Length) 
BEGIN
    UPDATE Gallery
       SET DateTimeLastEdited = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_Gallery_AU_Log_DateTimeRated
DROP TRIGGER IF EXISTS TR_Gallery_AU_Log_DateTimeRated;
CREATE TRIGGER TR_Gallery_AU_Log_DateTimeRated
         AFTER UPDATE
            ON Gallery
      FOR EACH ROW
          WHEN (NEW.Rating IS NOT NULL) AND 
               (NEW.Rating IS NOT OLD.Rating) 
BEGIN
    UPDATE Gallery
       SET DateTimeRated = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_GalleryTag_AI_Abort_TagTypeGroupTypeNotMatch
DROP TRIGGER IF EXISTS TR_GalleryTag_AI_Abort_TagTypeGroupTypeNotMatch;
CREATE TRIGGER TR_GalleryTag_AI_Abort_TagTypeGroupTypeNotMatch
         AFTER INSERT
            ON GalleryTag
      FOR EACH ROW
          WHEN NEW.TagGroupId IS NOT NULL
BEGIN
    SELECT CASE WHEN ( (
                   SELECT Tag.TagTypeId
                     FROM Tag
                    WHERE Tag.Id = NEW.TagId
               )
               IS NOT (
                          SELECT TagGroup.TagTypeId
                            FROM TagGroup
                           WHERE TagGroup.Id = NEW.TagGroupId
                      )
               ) THEN RAISE(ABORT, "TagType of Tag does not match the TagType of TagGroup.") END;
END;


-- Trigger: TR_GalleryTag_AI_Log_OnTagAdded_DateTimeLastTagged
DROP TRIGGER IF EXISTS TR_GalleryTag_AI_Log_OnTagAdded_DateTimeLastTagged;
CREATE TRIGGER TR_GalleryTag_AI_Log_OnTagAdded_DateTimeLastTagged
         AFTER INSERT
            ON GalleryTag
BEGIN
    UPDATE Gallery
       SET DateTimeLastTagged = strftime('%s', 'now') 
     WHERE Id = NEW.GalleryId;
END;


-- Trigger: TR_GalleryTag_AU_Abort_TagTypeGroupTypeNotMatch
DROP TRIGGER IF EXISTS TR_GalleryTag_AU_Abort_TagTypeGroupTypeNotMatch;
CREATE TRIGGER TR_GalleryTag_AU_Abort_TagTypeGroupTypeNotMatch
         AFTER UPDATE
            ON GalleryTag
      FOR EACH ROW
          WHEN NEW.TagGroupId IS NOT NULL
BEGIN
    SELECT CASE WHEN ( (
                   SELECT Tag.TagTypeId
                     FROM Tag
                    WHERE Tag.Id = NEW.TagId
               )
               IS NOT (
                          SELECT TagGroup.TagTypeId
                            FROM TagGroup
                           WHERE TagGroup.Id = NEW.TagGroupId
                      )
               ) THEN RAISE(ABORT, "TagType of Tag does not match the TagType of TagGroup.") END;
END;


-- Trigger: TR_GalleryTag_AU_Log_OnTagUpdated_Gallery_DateTimeLastTagged
DROP TRIGGER IF EXISTS TR_GalleryTag_AU_Log_OnTagUpdated_Gallery_DateTimeLastTagged;
CREATE TRIGGER TR_GalleryTag_AU_Log_OnTagUpdated_Gallery_DateTimeLastTagged
         AFTER UPDATE
            ON GalleryTag
      FOR EACH ROW
BEGIN
    UPDATE Gallery
       SET DateTimeLastTagged = strftime('%s', 'now') 
     WHERE Id = NEW.GalleryId OR 
           Id = OLD.GalleryId;
END;


-- Trigger: TR_SourceInfo_AI_Log_DateTimeAdded
DROP TRIGGER IF EXISTS TR_SourceInfo_AI_Log_DateTimeAdded;
CREATE TRIGGER TR_SourceInfo_AI_Log_DateTimeAdded
         AFTER INSERT
            ON SourceInfo
      FOR EACH ROW
BEGIN
    UPDATE SourceInfo
       SET DateTimeAdded = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_SourceInfo_AI_Log_DateTimeConverted
DROP TRIGGER IF EXISTS TR_SourceInfo_AI_Log_DateTimeConverted;
CREATE TRIGGER TR_SourceInfo_AI_Log_DateTimeConverted
         AFTER INSERT
            ON SourceInfo
      FOR EACH ROW
          WHEN DateTimeConverted IS NULL
BEGIN
    UPDATE SourceInfo
       SET DateTimeConverted = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_SourceInfo_AU_Log_DateTimeLastEdited
DROP TRIGGER IF EXISTS TR_SourceInfo_AU_Log_DateTimeLastEdited;
CREATE TRIGGER TR_SourceInfo_AU_Log_DateTimeLastEdited
         AFTER UPDATE
            ON SourceInfo
      FOR EACH ROW
          WHEN (OLD.DateTimeCreated IS NOT NEW.DateTimeCreated) OR 
               (OLD.DateTimePosted IS NOT NEW.DateTimePosted) OR 
               (OLD.Url IS NOT NEW.Url) OR 
               (OLD.CustomInfo IS NOT NEW.CustomInfo) OR 
               (OLD.PosterSourceGroupId IS NOT NEW.PosterSourceGroupId) OR 
               (OLD.CreatorSourceGroupId IS NOT NEW.CreatorSourceGroupId) OR 
               (OLD.HostSourceGroupId IS NOT NEW.HostSourceGroupId) 
BEGIN
    UPDATE SourceInfo
       SET DateTimeLastEdited = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


COMMIT TRANSACTION;
PRAGMA foreign_keys = on;

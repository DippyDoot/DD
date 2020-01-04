--
-- File generated with SQLiteStudio v3.2.1 on Sat Jan 4 03:59:45 2020
--
-- Text encoding used: UTF-8
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Collections
DROP TABLE IF EXISTS Collections;

CREATE TABLE Collections (
    CollectionTagId INTEGER CONSTRAINT NN_Collections_CollectionTagId NOT NULL
                            CONSTRAINT FK_Collections_CollectionTagId_Tags_Id REFERENCES Tags (Id) ON DELETE CASCADE
                                                                                                   ON UPDATE CASCADE,
    GalleryId       INTEGER CONSTRAINT NN_Collections_GalleryId NOT NULL
                            CONSTRAINT FK_Collections_GalleryId_Galleries_Id REFERENCES Galleries (Id) ON DELETE CASCADE
                                                                                                       ON UPDATE CASCADE,
    [Order]         INTEGER,
    CONSTRAINT PK_Collections_CollectionTagId_GalleryId PRIMARY KEY (
        CollectionTagId,
        GalleryId
    ),
    CONSTRAINT UQ_Collections_CollectionTagId_GalleryId UNIQUE (
        CollectionTagId,
        GalleryId
    )
);


-- Table: FavoriteGalleries
DROP TABLE IF EXISTS FavoriteGalleries;

CREATE TABLE FavoriteGalleries (
    Id        INTEGER CONSTRAINT PK_FavoriteGalleries_Id PRIMARY KEY AUTOINCREMENT
                      CONSTRAINT NN_FavoriteGalleries_Id NOT NULL
                      CONSTRAINT UQ_FavoriteGalleries_Id UNIQUE,
    GalleryId INTEGER CONSTRAINT FK_FavoriteGalleries_GalleryId_Galleries_Id REFERENCES Galleries (Id) ON DELETE CASCADE
                                                                                                       ON UPDATE CASCADE
                      CONSTRAINT UQ_FavoriteGalleries_GalleryId UNIQUE
                      CONSTRAINT NN_FavoriteGalleries_GalleryId NOT NULL
);


-- Table: FavoriteTags
DROP TABLE IF EXISTS FavoriteTags;

CREATE TABLE FavoriteTags (
    Id    INTEGER CONSTRAINT PK_FavoriteTags_Id PRIMARY KEY AUTOINCREMENT
                  CONSTRAINT UQ_FavoriteTags_Id UNIQUE
                  CONSTRAINT NN_FavoriteTags_Id NOT NULL,
    TagId INTEGER CONSTRAINT FK_FavoriteTags_TagId_Tags_Id REFERENCES Tags (Id) ON DELETE CASCADE
                                                                                ON UPDATE CASCADE
                  CONSTRAINT UQ_FavoriteTags_TagId UNIQUE
                  CONSTRAINT NN_FavoriteTags_TagId NOT NULL
);


-- Table: Galleries
DROP TABLE IF EXISTS Galleries;

CREATE TABLE Galleries (
    Id                 INTEGER    CONSTRAINT PK_Galleries_Id PRIMARY KEY AUTOINCREMENT
                                  CONSTRAINT UQ_Galleries_Id UNIQUE
                                  CONSTRAINT NN_Galleries_Id NOT NULL,
    Name               TEXT (300) CONSTRAINT CK_Galleries_Name_MaxLength_300 CHECK (length(Name) <= 300),
    NameCultureInfo    TEXT (17)  CONSTRAINT CK_Galleries_NameCultureInfo_MaxLength_17 CHECK (length(NameCultureInfo) <= 17),
    Description        TEXT (500) CONSTRAINT CK_Galleries_Description_MaxLegnth_500 CHECK (length(Description) <= 500),
    GalleryTypeId      INTEGER    CONSTRAINT NN_Galleries_GalleryTypeId NOT NULL
                                  CONSTRAINT FK_Galleries_GalleryTypeId REFERENCES GalleryTypes (Id) ON DELETE RESTRICT
                                                                                                     ON UPDATE CASCADE,
    ResourceFileId     INTEGER    CONSTRAINT NN_Galleries_ResourceFileId NOT NULL
                                  CONSTRAINT FK_Galleries_ResourceFileId REFERENCES ResourceFiles (Id) ON DELETE RESTRICT
                                                                                                       ON UPDATE CASCADE
                                  CONSTRAINT UQ_Galleries_ResourceFileId UNIQUE,
    Length             INTEGER,
    Rating             INTEGER,
    DateTimeRated      INTEGER,
    DateTimeLastEdited INTEGER,
    DateTimeLastTagged INTEGER
);


-- Table: GalleryAliases
DROP TABLE IF EXISTS GalleryAliases;

CREATE TABLE GalleryAliases (
    Id              INTEGER    CONSTRAINT PK_GalleryAliases_Id PRIMARY KEY AUTOINCREMENT
                               CONSTRAINT UQ_GalleryAliases_Id UNIQUE
                               CONSTRAINT NN_GalleryAliases_Id NOT NULL,
    GalleryId       INTEGER    CONSTRAINT FK_GalleryAliases_GalleryId REFERENCES Galleries (Id) ON DELETE CASCADE
                                                                                                ON UPDATE CASCADE
                               CONSTRAINT NN_GalleryAliases_GalleryId NOT NULL,
    Name            TEXT (300) CONSTRAINT NN_GalleryAliases_Name NOT NULL
                               CONSTRAINT CK_GalleryAliases_Name_MaxLength_300 CHECK (length(Name) <= 300),
    NameCultureInfo TEXT (17)  CONSTRAINT CK_GalleryAliases_Name_MaxLength_17 CHECK (length(NameCultureInfo) <= 17) 
);


-- Table: GalleryRelations
DROP TABLE IF EXISTS GalleryRelations;

CREATE TABLE GalleryRelations (
    Id            INTEGER CONSTRAINT FK_GalleryRelations_Id PRIMARY KEY AUTOINCREMENT
                          CONSTRAINT UQ_GalleryRelations_Id UNIQUE
                          CONSTRAINT NN_GalleryRelations_Id NOT NULL,
    FromGalleryId INTEGER CONSTRAINT NN_GalleryRelations_FromTagId NOT NULL
                          CONSTRAINT FK_GalleryRelations_FromTagId_Galleries_Id REFERENCES Galleries (Id) ON DELETE CASCADE
                                                                                                          ON UPDATE CASCADE,
    ToGalleryId   INTEGER CONSTRAINT NN_GalleryRelations_ToTagId NOT NULL
                          CONSTRAINT FK_GalleryRelations_ToTagId REFERENCES Galleries (Id),
    CONSTRAINT UQ_GalleryRelations_FromTagId_ToTagId UNIQUE (
        FromGalleryId,
        ToGalleryId
    )
);


-- Table: GalleryTags
DROP TABLE IF EXISTS GalleryTags;

CREATE TABLE GalleryTags (
    GalleryId  INTEGER CONSTRAINT NN_GalleryTags_GalleryId NOT NULL,
    TagId      INTEGER CONSTRAINT NN_GalleryTags_TagId NOT NULL,
    TagGroupId INTEGER CONSTRAINT FK_GalleryTags_TagGroupId REFERENCES TagGroups (Id) ON DELETE SET NULL
                                                                                      ON UPDATE CASCADE,
    CONSTRAINT PK_GalleryTags_GalleryId_TagId PRIMARY KEY (
        GalleryId,
        TagId
    ),
    CONSTRAINT UQ_GalleryTags_GalleryId_TagId UNIQUE (
        GalleryId,
        TagId
    )
);


-- Table: GalleryTypes
DROP TABLE IF EXISTS GalleryTypes;

CREATE TABLE GalleryTypes (
    Id   INTEGER   CONSTRAINT PK_GalleryTypes_Id PRIMARY KEY AUTOINCREMENT
                   CONSTRAINT UQ_GalleryTypes_Id UNIQUE
                   CONSTRAINT NN_GalleryTypes_Id NOT NULL,
    Name TEXT (17) CONSTRAINT UQ_GalleryTypes_Name UNIQUE
                   CONSTRAINT CK_GalleryTypes_Name_MaxLength_17 CHECK (length(Name) <= 17) 
);


-- Table: ResourceFiles
DROP TABLE IF EXISTS ResourceFiles;

CREATE TABLE ResourceFiles (
    Id           INTEGER    CONSTRAINT PK_ResourceFiles_Id PRIMARY KEY AUTOINCREMENT
                            CONSTRAINT UQ_ResourceFiles_Id UNIQUE
                            CONSTRAINT NN_ResourceFiles_Id NOT NULL,
    RelativePath TEXT (260) CONSTRAINT UQ_ResourceFiles_RelativePath UNIQUE
                            CONSTRAINT NN_ResourceFiles_RelativePath NOT NULL
                            CONSTRAINT CK_ResourceFiles_RelativePath_MaxLength_260 CHECK (length(RelativePath) <= 260),
    Hash         INTEGER    CONSTRAINT NN_ResourceFiles_Hash NOT NULL,
    SourceInfoId INTEGER    CONSTRAINT FK_ResourceFiles_SourceInfoId_SourceInfo_Id REFERENCES SourceInfo (Id) ON DELETE SET NULL
                                                                                                              ON UPDATE CASCADE
                            CONSTRAINT UQ_ResourceFiles_SourceInfoId UNIQUE
);


-- Table: SourceGroups
DROP TABLE IF EXISTS SourceGroups;

CREATE TABLE SourceGroups (
    Id          INTEGER     CONSTRAINT PK_SourceGroups_Id PRIMARY KEY AUTOINCREMENT
                            CONSTRAINT UQ_SourceGroups_Id UNIQUE
                            CONSTRAINT NN_SourceGroups_Id NOT NULL,
    Name        TEXT (100)  CONSTRAINT UQ_SourceGroups_Name UNIQUE
                            CONSTRAINT NN_SourceGroups_Name NOT NULL
                            CONSTRAINT CK_SourceGroups_Name_MaxLength_100 CHECK (length(Name) <= 100),
    Url         TEXT (2048) CONSTRAINT CK_SourceGroups_Url_MaxLength_2048 CHECK (length(Url) <= 2048),
    Description TEXT (8000) CONSTRAINT CK_SourceGroups_Descriptions_MaxLength_8000 CHECK (length(Description) <= 8000),
    TagId       INTEGER     CONSTRAINT FK_SourceGroups_TagId_Tags_Id REFERENCES Tags (Id) ON DELETE SET NULL
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
    PosterSourceGroupId  INTEGER     CONSTRAINT FK_SourceInfo_PosterSourceGroupId_SourceGroups_Id REFERENCES SourceGroups (Id) ON DELETE SET NULL
                                                                                                                               ON UPDATE CASCADE,
    CreatorSourceGroupId INTEGER     CONSTRAINT FK_SourceInfo_CreatorSourceGroupId_SourceGroups_Id REFERENCES Tags (Id) ON DELETE SET NULL
                                                                                                                        ON UPDATE CASCADE,
    HostSourceGroupId    INTEGER     CONSTRAINT FK_SourceInfo_HostSourceGroupId_SourceGroups_Id REFERENCES SourceGroups (Id) ON DELETE SET NULL
                                                                                                                             ON UPDATE CASCADE
);


-- Table: TagAliases
DROP TABLE IF EXISTS TagAliases;

CREATE TABLE TagAliases (
    Id              INTEGER    CONSTRAINT PK_TagAliases_Id PRIMARY KEY AUTOINCREMENT
                               CONSTRAINT UQ_TagAliases_Id UNIQUE
                               CONSTRAINT NN_TagAliases_Id NOT NULL,
    TagId           INTEGER    CONSTRAINT FK_TagAliases_TagId_Tags_Id REFERENCES Tags (Id) ON DELETE CASCADE
                                                                                           ON UPDATE CASCADE
                               CONSTRAINT NN_TagAliases_TagId NOT NULL,
    Name            TEXT (100) CONSTRAINT NN_TagAliases_Name NOT NULL
                               CONSTRAINT CK_TagAliases_Name_MaxLength_100 CHECK (length(Name) <= 100),
    NameCultureInfo TEXT (17)  CONSTRAINT CK_TagAliases_Name_MaxLength_17 CHECK (length(NameCultureInfo) <= 17) 
);


-- Table: TagGroups
DROP TABLE IF EXISTS TagGroups;

CREATE TABLE TagGroups (
    Id        INTEGER   CONSTRAINT PK_TagGroups_Id PRIMARY KEY AUTOINCREMENT
                        CONSTRAINT UQ_TagGroups_Id UNIQUE
                        CONSTRAINT NN_TagGroups_Id NOT NULL,
    Name      TEXT (30) CONSTRAINT UQ_TagGroups_Name UNIQUE
                        CONSTRAINT NN_TagGroups_Name NOT NULL
                        CONSTRAINT CK_TagGroups_Name_MaxLength_30 CHECK (length(Name) <= 30),
    TagTypeId INTEGER   CONSTRAINT NN_TagGroups_TagTypeId NOT NULL
                        CONSTRAINT FK_TagGroups_TagTypeId_TagTypes_Id REFERENCES TagTypes (Id) ON DELETE RESTRICT
                                                                                               ON UPDATE CASCADE
);


-- Table: TagRelations
DROP TABLE IF EXISTS TagRelations;

CREATE TABLE TagRelations (
    Id        INTEGER CONSTRAINT PK_TagRelations_Id PRIMARY KEY AUTOINCREMENT
                      CONSTRAINT UQ_TagRelations_Id UNIQUE
                      CONSTRAINT NN_TagRelations_Id NOT NULL,
    FromTagId INTEGER CONSTRAINT NN_TagRelations_FromTagId NOT NULL
                      CONSTRAINT FK_TagRelations_FromTagId_Tags_Id REFERENCES Tags (Id) ON DELETE CASCADE
                                                                                        ON UPDATE CASCADE,
    ToTagId   INTEGER CONSTRAINT FK_TagRelations_ToTagId_Tags_Id REFERENCES Tags (Id) ON DELETE CASCADE
                                                                                      ON UPDATE CASCADE
                      CONSTRAINT NN_TagRelations_ToTagId NOT NULL,
    CONSTRAINT UQ_TagRelations_FromTagId_ToTagId UNIQUE (
        FromTagId,
        ToTagId
    )
);


-- Table: Tags
DROP TABLE IF EXISTS Tags;

CREATE TABLE Tags (
    Id               INTEGER    CONSTRAINT PK_Tags_Id PRIMARY KEY AUTOINCREMENT
                                CONSTRAINT UQ_Tags_Id UNIQUE
                                CONSTRAINT NN_Tags_Id NOT NULL,
    Name             TEXT (100) CONSTRAINT NN_Tags_Name NOT NULL
                                CONSTRAINT CK_Tags_Name_MaxLength_100 CHECK (length(Name) <= 100),
    NameCultureInfo  TEXT (17)  CONSTRAINT CK_Tags_NameCultureInfo_MaxLength_17 CHECK (length(NameCultureInfo) <= 17),
    TagTypeId        INTEGER    CONSTRAINT FK_Tags_TagTypeId_TagTypes_Id REFERENCES TagTypes (Id) ON DELETE RESTRICT
                                                                                                  ON UPDATE CASCADE
                                CONSTRAINT NN_Tags_TagTypeId NOT NULL,
    Description      TEXT (500) CONSTRAINT CK_Tags_TagTypeId_MaxLength_500 CHECK (length(Description) <= 500),
    ShortDescription TEXT (100) CONSTRAINT CK_Tags_TagTypeId_MaxLength_100 CHECK (length(ShortDescription) <= 100),
    ResourceFileId   INTEGER    CONSTRAINT FK_Tags_ResourceFileId_ResourceFiles_Id REFERENCES ResourceFiles (Id) ON DELETE SET NULL
                                                                                                                 ON UPDATE CASCADE
                                CONSTRAINT UQ_Tags_ResourceFileId UNIQUE,
    Rating           INTEGER,
    CONSTRAINT UQ_Tags_Name_TagTypeId UNIQUE (
        Name,
        TagTypeId
    )
);


-- Table: TagTypes
DROP TABLE IF EXISTS TagTypes;

CREATE TABLE TagTypes (
    Id   INTEGER   CONSTRAINT PK_TagTypes_Id PRIMARY KEY AUTOINCREMENT
                   CONSTRAINT UQ_TagTypes_Id UNIQUE
                   CONSTRAINT NN_TagTypes_Id NOT NULL,
    Name TEXT (30) CONSTRAINT NN_TagTypes_Name NOT NULL
                   CONSTRAINT CK_TagTypes_Name_MaxLength_30 CHECK (length(Name) <= 30) 
                   CONSTRAINT UQ_TagTypes_Name UNIQUE
);


-- Index: IX_UQ_CO_GalleryRelations_FromGalleryId_ToGalleryId
DROP INDEX IF EXISTS IX_UQ_CO_GalleryRelations_FromGalleryId_ToGalleryId;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryRelations_FromGalleryId_ToGalleryId ON GalleryRelations (
    FromGalleryId,
    ToGalleryId
);


-- Index: IX_UQ_CO_GalleryRelations_ToGalleryId_FromGalleryId
DROP INDEX IF EXISTS IX_UQ_CO_GalleryRelations_ToGalleryId_FromGalleryId;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryRelations_ToGalleryId_FromGalleryId ON GalleryRelations (
    ToGalleryId,
    FromGalleryId
);


-- Index: IX_UQ_CO_GalleryTags_GalleryId_TagGroupId_TagId
DROP INDEX IF EXISTS IX_UQ_CO_GalleryTags_GalleryId_TagGroupId_TagId;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryTags_GalleryId_TagGroupId_TagId ON GalleryTags (
    GalleryId,
    TagGroupId,
    TagId
);


-- Index: IX_UQ_CO_GalleryTags_TagId_GalleryId
DROP INDEX IF EXISTS IX_UQ_CO_GalleryTags_TagId_GalleryId;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryTags_TagId_GalleryId ON GalleryTags (
    TagId,
    GalleryId
);


-- Index: IX_UQ_CO_GalleryTypes_Id_Name
DROP INDEX IF EXISTS IX_UQ_CO_GalleryTypes_Id_Name;

CREATE UNIQUE INDEX IX_UQ_CO_GalleryTypes_Id_Name ON GalleryTypes (
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


-- Index: IX_UQ_CO_TagGroups_Name_Id
DROP INDEX IF EXISTS IX_UQ_CO_TagGroups_Name_Id;

CREATE UNIQUE INDEX IX_UQ_CO_TagGroups_Name_Id ON TagGroups (
    Name,
    Id
);


-- Index: IX_UQ_CO_TagGroups_TagTypeId_Id
DROP INDEX IF EXISTS IX_UQ_CO_TagGroups_TagTypeId_Id;

CREATE UNIQUE INDEX IX_UQ_CO_TagGroups_TagTypeId_Id ON TagGroups (
    TagTypeId,
    Id
);


-- Index: IX_UQ_CO_TagRelations_FromTagId_ToTagId
DROP INDEX IF EXISTS IX_UQ_CO_TagRelations_FromTagId_ToTagId;

CREATE UNIQUE INDEX IX_UQ_CO_TagRelations_FromTagId_ToTagId ON TagRelations (
    FromTagId,
    ToTagId
);


-- Index: IX_UQ_CO_TagRelations_ToTagId_FromTagId
DROP INDEX IF EXISTS IX_UQ_CO_TagRelations_ToTagId_FromTagId;

CREATE UNIQUE INDEX IX_UQ_CO_TagRelations_ToTagId_FromTagId ON TagRelations (
    ToTagId,
    FromTagId
);


-- Index: IX_UQ_CO_Tags_Name_TagTypeId_Id
DROP INDEX IF EXISTS IX_UQ_CO_Tags_Name_TagTypeId_Id;

CREATE UNIQUE INDEX IX_UQ_CO_Tags_Name_TagTypeId_Id ON Tags (
    Name,
    TagTypeId,
    Id
);


-- Index: IX_UQ_CO_TagTypes_Id_Name
DROP INDEX IF EXISTS IX_UQ_CO_TagTypes_Id_Name;

CREATE UNIQUE INDEX IX_UQ_CO_TagTypes_Id_Name ON TagTypes (
    Id,
    Name
);


-- Index: IX_UQ_CO_TagTypes_Name_Id
DROP INDEX IF EXISTS IX_UQ_CO_TagTypes_Name_Id;

CREATE UNIQUE INDEX IX_UQ_CO_TagTypes_Name_Id ON TagTypes (
    Name,
    Id
);


-- Index: IX_UQ_Collections_CollectionTagId_GalleryId
DROP INDEX IF EXISTS IX_UQ_Collections_CollectionTagId_GalleryId;

CREATE UNIQUE INDEX IX_UQ_Collections_CollectionTagId_GalleryId ON Collections (
    CollectionTagId,
    GalleryId
);


-- Index: IX_UQ_FavoriteGalleries_GalleryId
DROP INDEX IF EXISTS IX_UQ_FavoriteGalleries_GalleryId;

CREATE UNIQUE INDEX IX_UQ_FavoriteGalleries_GalleryId ON FavoriteGalleries (
    GalleryId
);


-- Index: IX_UQ_FavoriteGalleries_Id
DROP INDEX IF EXISTS IX_UQ_FavoriteGalleries_Id;

CREATE UNIQUE INDEX IX_UQ_FavoriteGalleries_Id ON FavoriteGalleries (
    Id
);


-- Index: IX_UQ_FavoriteTags_Id
DROP INDEX IF EXISTS IX_UQ_FavoriteTags_Id;

CREATE UNIQUE INDEX IX_UQ_FavoriteTags_Id ON FavoriteTags (
    Id
);


-- Index: IX_UQ_FavoriteTags_TagId
DROP INDEX IF EXISTS IX_UQ_FavoriteTags_TagId;

CREATE UNIQUE INDEX IX_UQ_FavoriteTags_TagId ON FavoriteTags (
    TagId
);


-- Index: IX_UQ_Galleries_GalleryTypeId_Id
DROP INDEX IF EXISTS IX_UQ_Galleries_GalleryTypeId_Id;

CREATE UNIQUE INDEX IX_UQ_Galleries_GalleryTypeId_Id ON Galleries (
    GalleryTypeId,
    Id
);


-- Index: IX_UQ_Galleries_Id
DROP INDEX IF EXISTS IX_UQ_Galleries_Id;

CREATE UNIQUE INDEX IX_UQ_Galleries_Id ON Galleries (
    Id
);


-- Index: IX_UQ_Galleries_Rating_Id
DROP INDEX IF EXISTS IX_UQ_Galleries_Rating_Id;

CREATE UNIQUE INDEX IX_UQ_Galleries_Rating_Id ON Galleries (
    Rating,
    Id
);


-- Index: IX_UQ_GalleryAliases_GalleryId_Id
DROP INDEX IF EXISTS IX_UQ_GalleryAliases_GalleryId_Id;

CREATE UNIQUE INDEX IX_UQ_GalleryAliases_GalleryId_Id ON GalleryAliases (
    GalleryId,
    Id
);


-- Index: IX_UQ_GalleryAliases_Id
DROP INDEX IF EXISTS IX_UQ_GalleryAliases_Id;

CREATE UNIQUE INDEX IX_UQ_GalleryAliases_Id ON GalleryAliases (
    Id
);


-- Index: IX_UQ_GalleryRelations_Id
DROP INDEX IF EXISTS IX_UQ_GalleryRelations_Id;

CREATE UNIQUE INDEX IX_UQ_GalleryRelations_Id ON GalleryRelations (
    Id
);


-- Index: IX_UQ_ResourceFiles_Id
DROP INDEX IF EXISTS IX_UQ_ResourceFiles_Id;

CREATE UNIQUE INDEX IX_UQ_ResourceFiles_Id ON ResourceFiles (
    Id
);


-- Index: IX_UQ_ResourceFiles_SourceInfoId
DROP INDEX IF EXISTS IX_UQ_ResourceFiles_SourceInfoId;

CREATE UNIQUE INDEX IX_UQ_ResourceFiles_SourceInfoId ON ResourceFiles (
    SourceInfoId
);


-- Index: IX_UQ_SourceGroups_Id
DROP INDEX IF EXISTS IX_UQ_SourceGroups_Id;

CREATE UNIQUE INDEX IX_UQ_SourceGroups_Id ON SourceGroups (
    Id
);


-- Index: IX_UQ_SourceInfo_Id
DROP INDEX IF EXISTS IX_UQ_SourceInfo_Id;

CREATE UNIQUE INDEX IX_UQ_SourceInfo_Id ON SourceInfo (
    Id
);


-- Index: IX_UQ_TagAliases_Id
DROP INDEX IF EXISTS IX_UQ_TagAliases_Id;

CREATE UNIQUE INDEX IX_UQ_TagAliases_Id ON TagAliases (
    Id
);


-- Index: IX_UQ_TagAliases_TagId_Id
DROP INDEX IF EXISTS IX_UQ_TagAliases_TagId_Id;

CREATE UNIQUE INDEX IX_UQ_TagAliases_TagId_Id ON TagAliases (
    TagId,
    Id
);


-- Index: IX_UQ_TagGroups_Id
DROP INDEX IF EXISTS IX_UQ_TagGroups_Id;

CREATE UNIQUE INDEX IX_UQ_TagGroups_Id ON TagGroups (
    Id
);


-- Index: IX_UQ_TagRelaitions_Id
DROP INDEX IF EXISTS IX_UQ_TagRelaitions_Id;

CREATE UNIQUE INDEX IX_UQ_TagRelaitions_Id ON TagRelations (
    Id
);


-- Index: IX_UQ_Tags_Id
DROP INDEX IF EXISTS IX_UQ_Tags_Id;

CREATE UNIQUE INDEX IX_UQ_Tags_Id ON Tags (
    Id
);


-- Index: IX_UQ_Tags_TagTypeId_Id
DROP INDEX IF EXISTS IX_UQ_Tags_TagTypeId_Id;

CREATE UNIQUE INDEX IX_UQ_Tags_TagTypeId_Id ON Tags (
    TagTypeId,
    Id
);


-- Trigger: TR_Galleries_AI_Log_DateTimeRated
DROP TRIGGER IF EXISTS TR_Galleries_AI_Log_DateTimeRated;
CREATE TRIGGER TR_Galleries_AI_Log_DateTimeRated
         AFTER INSERT
            ON Galleries
      FOR EACH ROW
          WHEN NEW.Rating IS NOT NULL
BEGIN
    UPDATE Galleries
       SET DateTimeRated = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_Galleries_AU_ClearLog_DateTimeRatedOnNullRating
DROP TRIGGER IF EXISTS TR_Galleries_AU_ClearLog_DateTimeRatedOnNullRating;
CREATE TRIGGER TR_Galleries_AU_ClearLog_DateTimeRatedOnNullRating
         AFTER UPDATE
            ON Galleries
      FOR EACH ROW
          WHEN (NEW.Rating IS NULL) AND 
               (NEW.Rating IS NOT OLD.Rating) 
BEGIN
    UPDATE Galleries
       SET DateTimeRated = NULL
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_Galleries_AU_Log_DateTimeLastEdited
DROP TRIGGER IF EXISTS TR_Galleries_AU_Log_DateTimeLastEdited;
CREATE TRIGGER TR_Galleries_AU_Log_DateTimeLastEdited
         AFTER UPDATE
            ON Galleries
      FOR EACH ROW
          WHEN (OLD.Name IS NOT NEW.Name) OR 
               (OLD.NameCultureInfo IS NOT NEW.NameCultureInfo) OR 
               (OLD.Description IS NOT NEW.Description) OR 
               (OLD.GalleryTypeId IS NOT NEW.GalleryTypeId) OR 
               (OLD.ResourceFileId IS NOT NEW.ResourceFileId) OR 
               (OLD.Length IS NOT NEW.Length) 
BEGIN
    UPDATE Galleries
       SET DateTimeLastEdited = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_Galleries_AU_Log_DateTimeRated
DROP TRIGGER IF EXISTS TR_Galleries_AU_Log_DateTimeRated;
CREATE TRIGGER TR_Galleries_AU_Log_DateTimeRated
         AFTER UPDATE
            ON Galleries
      FOR EACH ROW
          WHEN (NEW.Rating IS NOT NULL) AND 
               (NEW.Rating IS NOT OLD.Rating) 
BEGIN
    UPDATE Galleries
       SET DateTimeRated = strftime('%s', 'now') 
     WHERE _rowid_ = NEW._rowid_;
END;


-- Trigger: TR_GalleryTags_AI_Abort_TagTypeGroupTypeNotMatch
DROP TRIGGER IF EXISTS TR_GalleryTags_AI_Abort_TagTypeGroupTypeNotMatch;
CREATE TRIGGER TR_GalleryTags_AI_Abort_TagTypeGroupTypeNotMatch
         AFTER INSERT
            ON GalleryTags
      FOR EACH ROW
          WHEN NEW.TagGroupId IS NOT NULL
BEGIN
    SELECT CASE WHEN ( (
                   SELECT Tags.TagTypeId
                     FROM Tags
                    WHERE Tags.Id = NEW.TagId
               )
               IS NOT (
                          SELECT TagGroups.TagTypeId
                            FROM TagGroups
                           WHERE TagGroups.Id = NEW.TagGroupId
                      )
               ) THEN RAISE(ABORT, "TagType of Tag does not match the TagType of TagGroup.") END;
END;


-- Trigger: TR_GalleryTags_AI_Log_OnTagAdded_DateTimeLastTagged
DROP TRIGGER IF EXISTS TR_GalleryTags_AI_Log_OnTagAdded_DateTimeLastTagged;
CREATE TRIGGER TR_GalleryTags_AI_Log_OnTagAdded_DateTimeLastTagged
         AFTER INSERT
            ON GalleryTags
BEGIN
    UPDATE Galleries
       SET DateTimeLastTagged = strftime('%s', 'now') 
     WHERE Id = NEW.GalleryId;
END;


-- Trigger: TR_GalleryTags_AU_Abort_TagTypeGroupTypeNotMatch
DROP TRIGGER IF EXISTS TR_GalleryTags_AU_Abort_TagTypeGroupTypeNotMatch;
CREATE TRIGGER TR_GalleryTags_AU_Abort_TagTypeGroupTypeNotMatch
         AFTER UPDATE
            ON GalleryTags
      FOR EACH ROW
          WHEN NEW.TagGroupId IS NOT NULL
BEGIN
    SELECT CASE WHEN ( (
                   SELECT Tags.TagTypeId
                     FROM Tags
                    WHERE Tags.Id = NEW.TagId
               )
               IS NOT (
                          SELECT TagGroups.TagTypeId
                            FROM TagGroups
                           WHERE TagGroups.Id = NEW.TagGroupId
                      )
               ) THEN RAISE(ABORT, "TagType of Tag does not match the TagType of TagGroup.") END;
END;


-- Trigger: TR_GalleryTags_AU_Log_OnTagUpdated_Galleries_DateTimeLastTagged
DROP TRIGGER IF EXISTS TR_GalleryTags_AU_Log_OnTagUpdated_Galleries_DateTimeLastTagged;
CREATE TRIGGER TR_GalleryTags_AU_Log_OnTagUpdated_Galleries_DateTimeLastTagged
         AFTER UPDATE
            ON GalleryTags
      FOR EACH ROW
BEGIN
    UPDATE Galleries
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

INSERT INTO "Maintainer" (maintainer_nm,
                          email_addr_txt,
                          location_nm)
VALUES ('Giancarlo Razzolini', 'gialini@gnu.org', 'Brasil') ,
       ('Christian Hesse', 'heisse@archlinux.org', 'Germany') ,
       ('Sébastien Luttringer', 'lutt@based.net', 'Paris') ,
       ('Andrew Crerar', 'andrew@crerar.com', 'Spain') ,
       ('Morten Linderud', 'rudmor@sphere.net', 'Netherlands') ,
       ('Antonio Rojas', 'rojas.io@ion.io', 'Spain') ,
       ('Jan Alexander Steffens', 'jas@archlinux.org', 'Germany') ,
       ('Felix Yan', 'felixonmars@felixc.at', 'China') ,
       ('Evangelos Foutras', 'evangelos@foutrelis.com', 'Greece');


INSERT INTO "Package" (repository_nm,
                       maintainer_id,
                       package_nm,
                       architecture_nm,
                       last_updated_dt,
                       package_sz,
                       lincense_nm)
VALUES ('Core', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Giancarlo Razzolini'), 'glibc', 'x86_64', '2021-02-15', 9.8, 'GPL 3') ,
       ('Extra', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Christian Hesse'), 'git', 'x86_64', '2021-03-27', 5.8, 'GPL 2') ,
       ('Core', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Sébastien Luttringer'), 'grep', 'x86_64', '2020-11-11', 0.2, 'GPL 3') ,
       ('Community', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Andrew Crerar'), 'redis', 'x86_64', '2021-04-20', 0.9, 'BSD') ,
       ('Community', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Morten Linderud'), 'go', 'x86_64', '2021-04-03', 134, 'BSD') ,
       ('Community', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Antonio Rojas'), 'mathjax', 'any', '2021-04-24', 1.2, 'Apache') ,
       ('Extra', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Antonio Rojas'), 'cmake', 'x86_64', '2021-04-08', 8.3, 'Custom') ,
       ('Community', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Antonio Rojas'), 'geogebra', 'x86_64', '2021-04-26', 12.1, 'GPL 3') ,
       ('Extra', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Jan Alexander Steffens'), 'deluge', 'any', '2021-04-21', 1.9, 'GPL 3') ,
       ('Core', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Jan Alexander Steffens'), 'dbus', 'x86_64', '2020-07-05', 0.3, 'Custom') ,
       ('Extra', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Jan Alexander Steffens'), 'firefox', 'x86_64', '2021-04-19', 60.9, 'MPL') ,
       ('Core', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Jan Alexander Steffens'), 'linux', 'x86_64', '2021-04-22', 93.9, 'GPL 2') ,
       ('Community', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Felix Yan'), 'ccls', 'x86_64', '2021-04-07', 0.5, 'Apache') ,
       ('Extra', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Evangelos Foutras'), 'llvm', 'x86_64', '2021-02-19', 48.4, 'Custom') ,
       ('Core', (SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Evangelos Foutras'), 'flex', 'x86_64', '2019-11-18', 0.3, 'Custom');


INSERT INTO "PGP key" (maintainer_id,
                       fingerprint_txt)
VALUES ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Giancarlo Razzolini'), '0x8A77AEAB') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Christian Hesse'), '0x498E9CEE') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Sébastien Luttringer'), '0x2072D77A') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Andrew Crerar'), '0x8406FFF3') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Morten Linderud'), '0xE62EB915') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Antonio Rojas'), '0x941C2A25') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Jan Alexander Steffens'), '0x0D70FC30') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Felix Yan'), '0x30D7CB92') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Evangelos Foutras'), '0xA9999C34') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Felix Yan'), '0x41C31549') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Christian Hesse'), '0x4CE1C13E') ,
       ((SELECT id FROM "Maintainer" WHERE maintainer_nm = 'Antonio Rojas'), '0x3B94FA10');


INSERT INTO "Package Group" (group_nm,
                             is_base_flag)
VALUES ('base-devel', TRUE) ,
       ('gnu', TRUE) ,
       ('compilers', FALSE);


INSERT INTO "Package X  Package Group" (group_id,
                                        package_id)
VALUES ((SELECT id FROM "Package Group" WHERE group_nm = 'base-devel'), (SELECT id FROM "Package" WHERE package_nm = 'git')) ,
       ((SELECT id FROM "Package Group" WHERE group_nm = 'base-devel'), (SELECT id FROM "Package" WHERE package_nm = 'cmake')) ,
       ((SELECT id FROM "Package Group" WHERE group_nm = 'base-devel'), (SELECT id FROM "Package" WHERE package_nm = 'ccls')) ,
       ((SELECT id FROM "Package Group" WHERE group_nm = 'gnu'), (SELECT id FROM "Package" WHERE package_nm = 'glibc')) ,
       ((SELECT id FROM "Package Group" WHERE group_nm = 'gnu'), (SELECT id FROM "Package" WHERE package_nm = 'grep')) ,
       ((SELECT id FROM "Package Group" WHERE group_nm = 'gnu'), (SELECT id FROM "Package" WHERE package_nm = 'flex')) ,
       ((SELECT id FROM "Package Group" WHERE group_nm = 'compilers'), (SELECT id FROM "Package" WHERE package_nm = 'go')) ,
       ((SELECT id FROM "Package Group" WHERE group_nm = 'compilers'), (SELECT id FROM "Package" WHERE package_nm = 'llvm'));


INSERT INTO "Source Code" (package_id,
                           commits_cnt,
                           vcs_nm)
VALUES ((SELECT id FROM "Package" WHERE package_nm = 'glibc'), 15333, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'git'), 1234, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'grep'), 813, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'redis'), 18095, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'go'), 23345, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'mathjax'), 153, 'subversion') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'cmake'), 8093, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'geogebra'), 4021, 'subsersion') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'deluge'), 2094, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'dbus'), 13023, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'firefox'), 142832, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'linux'), 350945, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'ccls'), 1503, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'llvm'), 44353, 'git') ,
       ((SELECT id FROM "Package" WHERE package_nm = 'flex'), 1153, 'mercurial');


INSERT INTO "Developer" (developer_nm,
                         email_addr_txt)
VALUES ('Dennis Ritchie', 'rich@bell-labs.org') ,
       ('Brian Kernighan', 'brianken@gmail.com') ,
       ('Ken Thompson', 'thkenson@unix.net') ,
       ('Linus Torvalds', 'linus@kernel.org') ,
       ('Richard Stallman', 'rms@gnu.org') ,
       ('Blake Ross', 'blake@mozilla.org') ,
       ('Chris Lattner', 'chlat@llvm.org') ,
       ('Brian Fox', 'fox@gnu.org') ,
       ('Alan Turing', 'alan@tur.net') ,
       ('Donald Knuth', 'knuth@mit.edu') ,
       ('Bram Cohen', 'bram@bit-torrent.com');


INSERT INTO "Source code X Developer" (developer_id,
                                       source_id)
VALUES ((SELECT id FROM "Developer" WHERE developer_nm = 'Dennis Ritchie'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'glibc'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Dennis Ritchie'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'linux'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Brian Kernighan'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'go'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Brian Kernighan'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'grep'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Linus Torvalds'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'linux'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Linus Torvalds'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'git'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Richard Stallman'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'glibc'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Richard Stallman'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'flex'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Blake Ross'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'firefox'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Chris Lattner'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'llvm'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Brian Fox'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'glibc'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Brian Fox'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'grep'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Alan Turing'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'ccls'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Alan Turing'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'dbus'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Donald Knuth'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'mathjax'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Alan Turing'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'geogebra'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Bram Cohen'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'deluge'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Alan Turing'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'cmake'))) ,
       ((SELECT id FROM "Developer" WHERE developer_nm = 'Donald Knuth'), (SELECT id FROM "Source Code" WHERE package_id = (SELECT id FROM "Package" WHERE package_nm = 'redis')));

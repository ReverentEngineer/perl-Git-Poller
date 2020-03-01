Name:		   perl-Git-Poller
Version:	 %{_version}
Release:	 1%{?dist}
Summary:	 Polls repositories and performs actions on changes.
BuildArch: noarch

License:  MIT	
URL:	  	https://github.com/ReverentEngineer/%{name}
Source0:  https://github.com/ReverentEngineer/%{name}/archive/v%{version}.zip

BuildRequires:	
Requires:	perl-YAML, perl-Git

%description
perl-Git-Poller polls git repositories and performs actions ocn changes.

%prep
%{uncompress:%{SOURCE0}}

%build
perl Makefile.PL INSTALLDIRS=vendor NO_PACKLIST=1 NO_PERLLOCAL=1
%{make_build}

%install
%{make_install}
%{_fixperms} $RPM_BUILD_ROOT/*

%check
make test

%files
%doc



%changelog


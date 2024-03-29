requires "Data::Section" => "0.200002";
requires "Dist::Zilla" => "2.100950";
requires "Dist::Zilla::File::InMemory" => "0";
requires "Dist::Zilla::Role::BeforeRelease" => "0";
requires "Dist::Zilla::Role::FileGatherer" => "0";
requires "Dist::Zilla::Role::FileMunger" => "0";
requires "Dist::Zilla::Role::TextTemplate" => "0";
requires "File::pushd" => "0";
requires "Moose" => "0.99";
requires "Moose::Util::TypeConstraints" => "0";
requires "Sub::Exporter::ForMethods" => "0";
requires "autodie" => "2.00";
requires "namespace::autoclean" => "0.09";
requires "perl" => "5.006";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "Capture::Tiny" => "0";
  requires "Cwd" => "0";
  requires "Dist::Zilla::Tester" => "0";
  requires "ExtUtils::MakeMaker" => "0";
  requires "File::Spec" => "0";
  requires "Path::Tiny" => "0";
  requires "Test::Harness" => "0";
  requires "Test::More" => "0.88";
  requires "Try::Tiny" => "0";
  requires "perl" => "5.006";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.17";
  requires "perl" => "5.006";
};

on 'develop' => sub {
  requires "Dist::Zilla" => "5";
  requires "Dist::Zilla::PluginBundle::DAGOLDEN" => "0.072";
  requires "File::Spec" => "0";
  requires "File::Temp" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Meta" => "0";
  requires "Test::More" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
  requires "Test::Spelling" => "0.12";
};

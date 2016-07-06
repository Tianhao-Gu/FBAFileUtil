package FBAFileUtil::FBAFileUtilImpl;
use strict;
use Bio::KBase::Exceptions;
# Use Semantic Versioning (2.0.0-rc.1)
# http://semver.org 
our $VERSION = "0.0.1";
our $GIT_URL = "";
our $GIT_COMMIT_HASH = "";

=head1 NAME

FBAFileUtil

=head1 DESCRIPTION



=cut

#BEGIN_HEADER
use Cwd;
use Config::IniFiles;
use Data::UUID;

use Data::Dumper;

use Bio::KBase::workspace::Client;

# after submitting a system call, check the return code
sub check_system_call
{
    my $return_code = shift;

    if ($return_code == -1) {
        print "Failed to execute command.\n";
        die "Failed to execute command.";
    }
    elsif ($return_code & 127) {
        printf "\ncommand died with signal %d, %s coredump\n",
            ($return_code & 127),  ($return_code & 128) ? 'with' : 'without';
        die "Error running command.";
    }
    else {
        my $code = $return_code >> 8;
        print "\ncommand exited with value $code \n", ;
        if( $code != 0) {
            die "Error running command.";
        }
    }
    return();
}

# class method because it requires scratch config, this creates a new unique
# area for running a script
sub set_working_dir
{
    my $self = shift;

    my $ugen = Data::UUID->new;
    my $uuid_str = $ugen->create_str();
    my $path = $self->{'scratch'}.'/'.$uuid_str;

    mkdir $path;
    chdir $path;

    return $path;
}

# go through the a directory and get result files.  Probably a better perl way to
# do this, but it works
sub get_result_files
{
    my $path = shift;

    opendir(DIR, $path);
    my @files = readdir(DIR);
    closedir(DIR);

    my @filtered_files = ();
    my $file;
    foreach $file (@files) {
        next if $file eq '.' or $file eq '..';
        push @filtered_files, $file;
    }
    return @filtered_files;
}

sub get_ws_obj_ref
{
    my $self = shift;
    my $ws_name = shift;
    my $obj = shift;

    my $ws = new Bio::KBase::workspace::Client($self->{'workspace-url'});
    my $info = $ws->get_object_info_new({ objects=>[ { ref=>$ws_name.'/'.$obj } ] })->[0];

    return "$info->[6]/$info->[0]/$info->[4]";
}

#END_HEADER

sub new
{
    my($class, @args) = @_;
    my $self = {
    };
    bless $self, $class;
    #BEGIN_CONSTRUCTOR

    my $config_file = $ENV{ KB_DEPLOYMENT_CONFIG };
    my $cfg = Config::IniFiles->new(-file=>$config_file);

    my $ws_url = $cfg->val('FBAFileUtil','workspace-url');
    die "no workspace-url defined" unless $ws_url;
    $self->{'workspace-url'} = $ws_url;

    my $tpp = $cfg->val('FBAFileUtil','transform-plugin-path');
    die "no transform-plugin-path defined" unless $tpp;
    $self->{'transform-plugin-path'} = $tpp;

    my $scratch = $cfg->val('FBAFileUtil','scratch');
    die "no scratch space defined" unless $scratch;
    $self->{'scratch'} = $scratch;

    #END_CONSTRUCTOR

    if ($self->can('_init_instance'))
    {
	$self->_init_instance();
    }
    return $self;
}

=head1 METHODS



=head2 excel_file_to_model

  $return = $obj->excel_file_to_model($p)

=over 4

=item Parameter and return types

=begin html

<pre>
$p is a FBAFileUtil.ModelCreationParams
$return is a FBAFileUtil.WorkspaceRef
ModelCreationParams is a reference to a hash where the following keys are defined:
	model_file has a value which is a FBAFileUtil.File
	model_name has a value which is a string
	workspace_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string
WorkspaceRef is a reference to a hash where the following keys are defined:
	ref has a value which is a string

</pre>

=end html

=begin text

$p is a FBAFileUtil.ModelCreationParams
$return is a FBAFileUtil.WorkspaceRef
ModelCreationParams is a reference to a hash where the following keys are defined:
	model_file has a value which is a FBAFileUtil.File
	model_name has a value which is a string
	workspace_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string
WorkspaceRef is a reference to a hash where the following keys are defined:
	ref has a value which is a string


=end text



=item Description



=back

=cut

sub excel_file_to_model
{
    my $self = shift;
    my($p) = @_;

    my @_bad_arguments;
    (ref($p) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"p\" (value was \"$p\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to excel_file_to_model:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'excel_file_to_model');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($return);
    #BEGIN excel_file_to_model
    #END excel_file_to_model
    my @_bad_returns;
    (ref($return) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"return\" (value was \"$return\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to excel_file_to_model:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'excel_file_to_model');
    }
    return($return);
}




=head2 sbml_file_to_model

  $return = $obj->sbml_file_to_model($p)

=over 4

=item Parameter and return types

=begin html

<pre>
$p is a FBAFileUtil.ModelCreationParams
$return is a FBAFileUtil.WorkspaceRef
ModelCreationParams is a reference to a hash where the following keys are defined:
	model_file has a value which is a FBAFileUtil.File
	model_name has a value which is a string
	workspace_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string
WorkspaceRef is a reference to a hash where the following keys are defined:
	ref has a value which is a string

</pre>

=end html

=begin text

$p is a FBAFileUtil.ModelCreationParams
$return is a FBAFileUtil.WorkspaceRef
ModelCreationParams is a reference to a hash where the following keys are defined:
	model_file has a value which is a FBAFileUtil.File
	model_name has a value which is a string
	workspace_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string
WorkspaceRef is a reference to a hash where the following keys are defined:
	ref has a value which is a string


=end text



=item Description



=back

=cut

sub sbml_file_to_model
{
    my $self = shift;
    my($p) = @_;

    my @_bad_arguments;
    (ref($p) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"p\" (value was \"$p\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to sbml_file_to_model:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'sbml_file_to_model');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($return);
    #BEGIN sbml_file_to_model

    # setup output directory and script call
    my $working_dir = $self->set_working_dir();
    my $sbmlValidateScript = $self->{'transform-plugin-path'}.'/scripts/validate/trns_validate_SBML_FBAModel.py';
    my $uploadScript = $self->{'transform-plugin-path'}.'/scripts/upload/trns_transform_SBML_FBAModel_to_KBaseFBA_FBAModel.pl';


    # Skip SBML Validation - some missing dependencies exist here... need to install libsbml and install validate to 
    #my @vArgs = ("python", $sbmlValidateScript,
    #                '--input_file_name', $p->{'model_file'}->{'path'},
    #                '--working_directory', $working_dir);
    #print("Running: @vArgs \n");
    #my $vRet = system(@vArgs);
    #check_system_call($vRet);


#"input_file_name|s=s"  => \$In_RxnFile,
#       "compounds|c=s"      => \$In_CpdFile,
#       "object_name|o=s"    => \$Out_Object,
#       "workspace_name|w=s" => \$Out_WS,
#       "genome|g=s"         => \$Genome,
#       "biomass|b=s@"        => \$Biomass,
#       "workspace_service_url=s" => \$wsurl,
#       "fba_service_url=s" => \$fbaurl,

    my @uploadArgs = ("perl", $uploadScript,
                    '--input_file_name', $p->{'model_file'}->{'path'},
                    '--object_name', $p->{'model_name'},
                    '--workspace_name', $p->{'workspace_name'},
                    '--workspace_service_url', $self->{'workspace-url'},
                    '--fba_service_url', 'impl');

    #                '--genome', $model->{'genome'},
    #                '--biomass', $model->{'biomass'},
    #                '--compounds', $model->{'compounds_file'}->{'path'},
                    
                    #'--input_file_name', $model->{'input_file'}->{'path'},
                    
    print("Running: @uploadArgs \n");
    my $ret = system(@uploadArgs);
    check_system_call($ret);

    # get WS info so we can determine the ws reference to return
    my $ref = $self->get_ws_obj_ref($p->{'workspace_name'}, $p->{'model_name'});
    $return = { ref => $ref };
    print("Saved new FBA Model to: $ref\n");

    #END sbml_file_to_model
    my @_bad_returns;
    (ref($return) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"return\" (value was \"$return\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to sbml_file_to_model:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'sbml_file_to_model');
    }
    return($return);
}




=head2 tsv_file_to_model

  $return = $obj->tsv_file_to_model($p)

=over 4

=item Parameter and return types

=begin html

<pre>
$p is a FBAFileUtil.ModelCreationParams
$return is a FBAFileUtil.WorkspaceRef
ModelCreationParams is a reference to a hash where the following keys are defined:
	model_file has a value which is a FBAFileUtil.File
	model_name has a value which is a string
	workspace_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string
WorkspaceRef is a reference to a hash where the following keys are defined:
	ref has a value which is a string

</pre>

=end html

=begin text

$p is a FBAFileUtil.ModelCreationParams
$return is a FBAFileUtil.WorkspaceRef
ModelCreationParams is a reference to a hash where the following keys are defined:
	model_file has a value which is a FBAFileUtil.File
	model_name has a value which is a string
	workspace_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string
WorkspaceRef is a reference to a hash where the following keys are defined:
	ref has a value which is a string


=end text



=item Description



=back

=cut

sub tsv_file_to_model
{
    my $self = shift;
    my($p) = @_;

    my @_bad_arguments;
    (ref($p) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"p\" (value was \"$p\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to tsv_file_to_model:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'tsv_file_to_model');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($return);
    #BEGIN tsv_file_to_model
    #END tsv_file_to_model
    my @_bad_returns;
    (ref($return) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"return\" (value was \"$return\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to tsv_file_to_model:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'tsv_file_to_model');
    }
    return($return);
}




=head2 model_to_excel_file

  $f = $obj->model_to_excel_file($model)

=over 4

=item Parameter and return types

=begin html

<pre>
$model is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$model is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description



=back

=cut

sub model_to_excel_file
{
    my $self = shift;
    my($model) = @_;

    my @_bad_arguments;
    (ref($model) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"model\" (value was \"$model\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to model_to_excel_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'model_to_excel_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN model_to_excel_file
    #END model_to_excel_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to model_to_excel_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'model_to_excel_file');
    }
    return($f);
}




=head2 model_to_sbml_file

  $f = $obj->model_to_sbml_file($model)

=over 4

=item Parameter and return types

=begin html

<pre>
$model is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$model is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description



=back

=cut

sub model_to_sbml_file
{
    my $self = shift;
    my($model) = @_;

    my @_bad_arguments;
    (ref($model) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"model\" (value was \"$model\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to model_to_sbml_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'model_to_sbml_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN model_to_sbml_file

    # TODO: better input error checking
    my $output_dir = $self->set_working_dir();
    my $script = $self->{'transform-plugin-path'}.'/scripts/download/trns_transform_KBaseFBA_FBAModel_to_SBML_FBAModel.pl';

    # [object_name=s', 'workspace object name from which the input is to be read'],
    # ['workspace_name=s', 'workspace name from which the input is to be read'],
    # ['workspace_service_url=s', 'workspace service url to pull from']
    my @args = ("perl", $script, 
                    '--object_name', $model->{'model_name'},
                    '--workspace_name', $model->{'workspace_name'},
                    '--workspace_service_url', $self->{'workspace-url'},
                    '--fba_service_url', 'impl');
    print("Running: @args \n");

    my $ret = system(@args);
    check_system_call($ret);

    # collect output
    my @files = get_result_files($output_dir);
    if( scalar(@files) != 1 ) {
        print("Generated : @files");
        die 'Incorrect number of files was generated! Expected 1 file.';
    }
    $f = { path => $output_dir . '/' . $files[0] };

    #END model_to_sbml_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to model_to_sbml_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'model_to_sbml_file');
    }
    return($f);
}




=head2 model_to_tsv_file

  $f = $obj->model_to_tsv_file($model)

=over 4

=item Parameter and return types

=begin html

<pre>
$model is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$model is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description



=back

=cut

sub model_to_tsv_file
{
    my $self = shift;
    my($model) = @_;

    my @_bad_arguments;
    (ref($model) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"model\" (value was \"$model\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to model_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'model_to_tsv_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN model_to_tsv_file
    #END model_to_tsv_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to model_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'model_to_tsv_file');
    }
    return($f);
}




=head2 fba_to_excel_file

  $f = $obj->fba_to_excel_file($fba)

=over 4

=item Parameter and return types

=begin html

<pre>
$fba is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$fba is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description

****** FBA Result Converters ******

=back

=cut

sub fba_to_excel_file
{
    my $self = shift;
    my($fba) = @_;

    my @_bad_arguments;
    (ref($fba) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"fba\" (value was \"$fba\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to fba_to_excel_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'fba_to_excel_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN fba_to_excel_file
    #END fba_to_excel_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to fba_to_excel_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'fba_to_excel_file');
    }
    return($f);
}




=head2 fba_to_tsv_file

  $f = $obj->fba_to_tsv_file($fba)

=over 4

=item Parameter and return types

=begin html

<pre>
$fba is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$fba is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description



=back

=cut

sub fba_to_tsv_file
{
    my $self = shift;
    my($fba) = @_;

    my @_bad_arguments;
    (ref($fba) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"fba\" (value was \"$fba\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to fba_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'fba_to_tsv_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN fba_to_tsv_file
    #END fba_to_tsv_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to fba_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'fba_to_tsv_file');
    }
    return($f);
}




=head2 tsv_file_to_media

  $obj->tsv_file_to_media()

=over 4

=item Parameter and return types

=begin html

<pre>

</pre>

=end html

=begin text



=end text



=item Description

****** Media Converters *********

=back

=cut

sub tsv_file_to_media
{
    my $self = shift;

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    #BEGIN tsv_file_to_media
    #END tsv_file_to_media
    return();
}




=head2 media_to_tsv_file

  $f = $obj->media_to_tsv_file($media)

=over 4

=item Parameter and return types

=begin html

<pre>
$media is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$media is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description



=back

=cut

sub media_to_tsv_file
{
    my $self = shift;
    my($media) = @_;

    my @_bad_arguments;
    (ref($media) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"media\" (value was \"$media\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to media_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'media_to_tsv_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN media_to_tsv_file
    #END media_to_tsv_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to media_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'media_to_tsv_file');
    }
    return($f);
}




=head2 tsv_file_to_phenotype_set

  $obj->tsv_file_to_phenotype_set()

=over 4

=item Parameter and return types

=begin html

<pre>

</pre>

=end html

=begin text



=end text



=item Description

****** Phenotype Data Converters *******

=back

=cut

sub tsv_file_to_phenotype_set
{
    my $self = shift;

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    #BEGIN tsv_file_to_phenotype_set
    #END tsv_file_to_phenotype_set
    return();
}




=head2 phenotype_set_to_tsv_file

  $f = $obj->phenotype_set_to_tsv_file($phenotype)

=over 4

=item Parameter and return types

=begin html

<pre>
$phenotype is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$phenotype is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description



=back

=cut

sub phenotype_set_to_tsv_file
{
    my $self = shift;
    my($phenotype) = @_;

    my @_bad_arguments;
    (ref($phenotype) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"phenotype\" (value was \"$phenotype\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to phenotype_set_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'phenotype_set_to_tsv_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN phenotype_set_to_tsv_file
    #END phenotype_set_to_tsv_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to phenotype_set_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'phenotype_set_to_tsv_file');
    }
    return($f);
}




=head2 phenotype_simulation_set_to_excel_file

  $f = $obj->phenotype_simulation_set_to_excel_file($pss)

=over 4

=item Parameter and return types

=begin html

<pre>
$pss is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$pss is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description



=back

=cut

sub phenotype_simulation_set_to_excel_file
{
    my $self = shift;
    my($pss) = @_;

    my @_bad_arguments;
    (ref($pss) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"pss\" (value was \"$pss\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to phenotype_simulation_set_to_excel_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'phenotype_simulation_set_to_excel_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN phenotype_simulation_set_to_excel_file
    #END phenotype_simulation_set_to_excel_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to phenotype_simulation_set_to_excel_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'phenotype_simulation_set_to_excel_file');
    }
    return($f);
}




=head2 phenotype_simulation_set_to_tsv_file

  $f = $obj->phenotype_simulation_set_to_tsv_file($pss)

=over 4

=item Parameter and return types

=begin html

<pre>
$pss is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$pss is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description



=back

=cut

sub phenotype_simulation_set_to_tsv_file
{
    my $self = shift;
    my($pss) = @_;

    my @_bad_arguments;
    (ref($pss) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"pss\" (value was \"$pss\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to phenotype_simulation_set_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'phenotype_simulation_set_to_tsv_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN phenotype_simulation_set_to_tsv_file
    #END phenotype_simulation_set_to_tsv_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to phenotype_simulation_set_to_tsv_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'phenotype_simulation_set_to_tsv_file');
    }
    return($f);
}




=head2 phenotype_simulation_set_to_excel_file

  $f = $obj->phenotype_simulation_set_to_excel_file($pss)

=over 4

=item Parameter and return types

=begin html

<pre>
$pss is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string

</pre>

=end html

=begin text

$pss is a FBAFileUtil.ObjectSelection
$f is a FBAFileUtil.File
ObjectSelection is a reference to a hash where the following keys are defined:
	workspace_name has a value which is a string
	model_name has a value which is a string
File is a reference to a hash where the following keys are defined:
	path has a value which is a string


=end text



=item Description



=back

=cut

sub phenotype_simulation_set_to_excel_file
{
    my $self = shift;
    my($pss) = @_;

    my @_bad_arguments;
    (ref($pss) eq 'HASH') or push(@_bad_arguments, "Invalid type for argument \"pss\" (value was \"$pss\")");
    if (@_bad_arguments) {
	my $msg = "Invalid arguments passed to phenotype_simulation_set_to_excel_file:\n" . join("", map { "\t$_\n" } @_bad_arguments);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'phenotype_simulation_set_to_excel_file');
    }

    my $ctx = $FBAFileUtil::FBAFileUtilServer::CallContext;
    my($f);
    #BEGIN phenotype_simulation_set_to_excel_file
    #END phenotype_simulation_set_to_excel_file
    my @_bad_returns;
    (ref($f) eq 'HASH') or push(@_bad_returns, "Invalid type for return variable \"f\" (value was \"$f\")");
    if (@_bad_returns) {
	my $msg = "Invalid returns passed to phenotype_simulation_set_to_excel_file:\n" . join("", map { "\t$_\n" } @_bad_returns);
	Bio::KBase::Exceptions::ArgumentValidationError->throw(error => $msg,
							       method_name => 'phenotype_simulation_set_to_excel_file');
    }
    return($f);
}




=head2 status 

  $return = $obj->status()

=over 4

=item Parameter and return types

=begin html

<pre>
$return is a string
</pre>

=end html

=begin text

$return is a string

=end text

=item Description

Return the module status. This is a structure including Semantic Versioning number, state and git info.

=back

=cut

sub status {
    my($return);
    #BEGIN_STATUS
    $return = {"state" => "OK", "message" => "", "version" => $VERSION,
               "git_url" => $GIT_URL, "git_commit_hash" => $GIT_COMMIT_HASH};
    #END_STATUS
    return($return);
}

=head1 TYPES



=head2 File

=over 4



=item Description

***** FBA Model Converters *******


=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
path has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
path has a value which is a string


=end text

=back



=head2 WorkspaceRef

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
ref has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
ref has a value which is a string


=end text

=back



=head2 ModelCreationParams

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
model_file has a value which is a FBAFileUtil.File
model_name has a value which is a string
workspace_name has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
model_file has a value which is a FBAFileUtil.File
model_name has a value which is a string
workspace_name has a value which is a string


=end text

=back



=head2 ObjectSelection

=over 4



=item Definition

=begin html

<pre>
a reference to a hash where the following keys are defined:
workspace_name has a value which is a string
model_name has a value which is a string

</pre>

=end html

=begin text

a reference to a hash where the following keys are defined:
workspace_name has a value which is a string
model_name has a value which is a string


=end text

=back



=cut

1;
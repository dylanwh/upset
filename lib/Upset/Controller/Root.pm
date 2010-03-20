package Upset::Controller::Root;
use Moose;
use Try::Tiny;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
}

sub default :Path {
    my ( $self, $c ) = @_;
    $c->stash->{template} = 'not-found.tt';
    $c->response->status(404);
}

sub access_denied :Private {
    my ( $self, $c, $action ) = @_;

    $c->log->debug('access denied');
    $c->response->status(403);

    if ($c->user_exists) {
        $c->stash->{template} = 'access-denied.tt';
    }
    else {
        $c->forward('/login');
    }
}

sub begin :Private {
    my ( $self, $c ) = @_;
    $c->log->debug('begin!');
}

sub login :Local {
    my ( $self, $c ) = @_;

    # eval necessary because LWPx::ParanoidAgent
    # croaks if invalid URL is specified
    $c->stash->{template} = 'login.tt';
    #try {
        # Authenticate against OpenID to get user URL
        if ( $c->authenticate( {}, 'openid' ) ) {
            $c->flash->{'status_msg'} = 'OpenID login was successful.';

            # Create basic user entry unless already found
            # (or use auto_create_user: 1)
            unless ( $c->model('DB::User')->find( { url => $c->user->url } ) ) {
                $c->model('DB::User')->create( { url => $c->user->url } );
            }

            # Re-authenticate against local DBIC store
            if ( $c->authenticate( { url => $c->user->url }, 'dbic' ) ) {
                $c->log->debug("local login succeeded");
                $c->flash->{'status_msg'} = 'Login was successful.';
                $c->response->redirect( $c->uri_for("/") );
                $c->detach();
            }
            else {
                $c->log->error("local login failed for ${\$c->user->url}");
                $c->flash->{'error_msg'} = 'Local login failed.';
            }
        }
    #} catch { 
    #    $c->log->error( "Failure during login: " . $_ );
    #    $c->flash->{'error_msg'} = 'Failure during login: ' . $_;
    #};
}

sub logout :Local {
    my ($self, $c) = @_;
    $c->logout;
}

sub end : ActionClass('RenderView') {}

__PACKAGE__->meta->make_immutable;

1;

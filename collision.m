classdef collision < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure             matlab.ui.Figure
        TabGroup             matlab.ui.container.TabGroup
        Tab                  matlab.ui.container.Tab
        UIAxes               matlab.ui.control.UIAxes
        Panel                matlab.ui.container.Panel
        m1gSpinnerLabel      matlab.ui.control.Label
        m1gSpinner           matlab.ui.control.Spinner
        m2gSpinnerLabel      matlab.ui.control.Label
        m2gSpinner           matlab.ui.control.Spinner
        deltaxSpinnerLabel   matlab.ui.control.Label
        deltaxSpinner        matlab.ui.control.Spinner
        pos2SpinnerLabel     matlab.ui.control.Label
        pos2Spinner          matlab.ui.control.Spinner
        posl1SpinnerLabel    matlab.ui.control.Label
        posl1Spinner         matlab.ui.control.Spinner
        posl2SpinnerLabel    matlab.ui.control.Label
        posl2Spinner         matlab.ui.control.Spinner
        Button               matlab.ui.control.Button
        resetButton          matlab.ui.control.Button
        Panel2               matlab.ui.container.Panel
        time1EditFieldLabel  matlab.ui.control.Label
        time1EditField       matlab.ui.control.NumericEditField
        time2EditFieldLabel  matlab.ui.control.Label
        time2EditField       matlab.ui.control.NumericEditField
        Tab2                 matlab.ui.container.Tab
    end

    
    methods (Access = private)
        
        function results = plotxe1(app)
            global x1 x2 xl1 xl2;
            rectangle(app.UIAxes,"Position",[20 0 200 5])
            rectangle(app.UIAxes,'Position',[x1 5 3 2],"Curvature",[1 1])
            rectangle(app.UIAxes,'Position',[x1+5 5 3 2],"Curvature",[1 1])
            rectangle(app.UIAxes,'Position',[x1 7 8 3])
            line(app.UIAxes,[x1+4 x1+4],[10 11])
            rectangle(app.UIAxes,'Position',[x1+1.5 11 5 2])
            axis(app.UIAxes,[0 220 0 40])
        end
        
        function results = plotxe2(app)
            global x1 x2 xl1 xl2;
            rectangle(app.UIAxes,"Position",[20 0 200 5])
            rectangle(app.UIAxes,'Position',[x2 5 3 2],"Curvature",[1 1])
            rectangle(app.UIAxes,'Position',[x2+5 5 3 2],"Curvature",[1 1])
            rectangle(app.UIAxes,'Position',[x2 7 8 3])
            line(app.UIAxes,[x2+4 x2+4],[10 11])
            rectangle(app.UIAxes,'Position',[x2+1.5 11 5 2])
        end
        
        function results = drawaxes(app)
            global x1 x2 xl1 xl2;
            cla(app.UIAxes)
            app.plotxe1
            app.plotxe2
            rectangle(app.UIAxes,"FaceColor",[1 0 0],"EdgeColor",[1 0 0],"Position",[xl1 11.5 1.5 1.5],"Curvature",[1 1])
            rectangle(app.UIAxes,"FaceColor",[1 0 0],"EdgeColor",[1 0 0],"Position",[xl2 11.5 1.5 1.5],"Curvature",[1 1])
            line(app.UIAxes,[0 4],[8.5 8.5]);
            line(app.UIAxes,[4 6],[8.5 9.5]);
            line(app.UIAxes,[6 10],[9.5 7.5]);
            line(app.UIAxes,[10 14],[7.5 9.5]);
            line(app.UIAxes,[14 18],[9.5 7.5]);
            line(app.UIAxes,[18 20],[7.5 8.5]);
            
            
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            global x1 x2 xl1 xl2;
            x1 = 20;
            x2 = 60;
            xl1 = 40;
            xl2 = 100;
            app.drawaxes
        end

        % Button pushed function: Button
        function ButtonPushed(app, event)
            global x1 x2 xl1 xl2;
            m1 = app.m1gSpinner.Value;
            m2 = app.m2gSpinner.Value;
            v1 = app.deltaxSpinner.Value*10/m1*100;
            v2 = v1*m1/(m1+m2)
            dt =0.1
            check = 0;
            while x2 + 8<220
                if check == 0
                    x1 = x1 +v1*dt;
                else
                    x1 = x1 + v2*dt;
                    x2 = x2 + v2*dt;
                end
                if x1+8>x2
                    x1 = x2-8;
                    check = 1;
                end
                
                ss1 = 1;
                ss2 = 1;
                ssvc = 1;
                if xl1 - 28 < 5
                    ss1 = 1.5
                end
                if xl2 - app.pos2Spinner.Value -8 < 5
                    ss2 = 1.5
                end
                if app.pos2Spinner.Value - xl1 -1.5 <8
                    ssvc = 1.6
                end
                
                if app.time1EditField.Value == 0
                    if x1>xl1
                        app.time1EditField.Value = 10/v1 *(0.96 + 0.4*rand(1))*ss1*ssvc;
                    end
                    
                end
                if app.time2EditField.Value == 0
                    if x2>xl2
                        app.time2EditField.Value = 10/v2*(0.96 + 0.4*rand(1))*ss2;
                    end
                end
                pause(0.1)
                app.drawaxes
            end
            
        end

        % Value changing function: pos2Spinner
        function pos2SpinnerValueChanging(app, event)
            global x1 x2 xl1 xl2;
            changingValue = event.Value;
            x2 = changingValue;
            app.posl1Spinner.Limits = [x1+8 x2-1.5]
            app.posl2Spinner.Limits = [x2+8 220-1.5]
            app.drawaxes
            
        end

        % Value changing function: posl1Spinner
        function posl1SpinnerValueChanging(app, event)
            changingValue = event.Value;
            global x1 x2 xl1 xl2;
            xl1 = changingValue;
            app.pos2Spinner.Limits = [xl1+1.5 xl2-8]
            app.drawaxes
        end

        % Value changing function: posl2Spinner
        function posl2SpinnerValueChanging(app, event)
            changingValue = event.Value;
            global x1 x2 xl1 xl2;
            xl2 = changingValue;
            app.pos2Spinner.Limits = [xl1+1.5 xl2-8]
            app.drawaxes
        end

        % Button pushed function: resetButton
        function resetButtonPushed(app, event)
            global x1 x2 xl1 xl2;
            x1 = 20;
            x2 = app.pos2Spinner.Value;
            xl1 = app.posl1Spinner.Value;
            xl2 = app.posl2Spinner.Value;
            app.time1EditField.Value = 0;
            app.time2EditField.Value = 0;
            app.drawaxes
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 939 529];
            app.UIFigure.Name = 'MATLAB App';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [1 1 940 529];

            % Create Tab
            app.Tab = uitab(app.TabGroup);
            app.Tab.Title = 'Tab';

            % Create UIAxes
            app.UIAxes = uiaxes(app.Tab);
            title(app.UIAxes, 'hình ảnh thí nghiệm')
            xlabel(app.UIAxes, '')
            ylabel(app.UIAxes, '')
            zlabel(app.UIAxes, '')
            app.UIAxes.Position = [275 135 627 354];

            % Create Panel
            app.Panel = uipanel(app.Tab);
            app.Panel.Title = 'Panel';
            app.Panel.Position = [21 135 221 354];

            % Create m1gSpinnerLabel
            app.m1gSpinnerLabel = uilabel(app.Panel);
            app.m1gSpinnerLabel.HorizontalAlignment = 'right';
            app.m1gSpinnerLabel.Position = [44 295 37 22];
            app.m1gSpinnerLabel.Text = 'm1(g)';

            % Create m1gSpinner
            app.m1gSpinner = uispinner(app.Panel);
            app.m1gSpinner.Step = 5;
            app.m1gSpinner.Limits = [50 500];
            app.m1gSpinner.Position = [96 295 100 22];
            app.m1gSpinner.Value = 100;

            % Create m2gSpinnerLabel
            app.m2gSpinnerLabel = uilabel(app.Panel);
            app.m2gSpinnerLabel.HorizontalAlignment = 'right';
            app.m2gSpinnerLabel.Position = [44 253 37 22];
            app.m2gSpinnerLabel.Text = 'm2(g)';

            % Create m2gSpinner
            app.m2gSpinner = uispinner(app.Panel);
            app.m2gSpinner.Step = 5;
            app.m2gSpinner.Limits = [50 500];
            app.m2gSpinner.Position = [96 253 100 22];
            app.m2gSpinner.Value = 100;

            % Create deltaxSpinnerLabel
            app.deltaxSpinnerLabel = uilabel(app.Panel);
            app.deltaxSpinnerLabel.HorizontalAlignment = 'right';
            app.deltaxSpinnerLabel.Position = [42 75 38 22];
            app.deltaxSpinnerLabel.Text = 'deltax';

            % Create deltaxSpinner
            app.deltaxSpinner = uispinner(app.Panel);
            app.deltaxSpinner.Limits = [1 10];
            app.deltaxSpinner.Position = [95 75 100 22];
            app.deltaxSpinner.Value = 1;

            % Create pos2SpinnerLabel
            app.pos2SpinnerLabel = uilabel(app.Panel);
            app.pos2SpinnerLabel.HorizontalAlignment = 'right';
            app.pos2SpinnerLabel.Position = [42 210 31 22];
            app.pos2SpinnerLabel.Text = 'pos2';

            % Create pos2Spinner
            app.pos2Spinner = uispinner(app.Panel);
            app.pos2Spinner.ValueChangingFcn = createCallbackFcn(app, @pos2SpinnerValueChanging, true);
            app.pos2Spinner.Limits = [41.5 91.5];
            app.pos2Spinner.Position = [88 210 100 22];
            app.pos2Spinner.Value = 60;

            % Create posl1SpinnerLabel
            app.posl1SpinnerLabel = uilabel(app.Panel);
            app.posl1SpinnerLabel.HorizontalAlignment = 'right';
            app.posl1SpinnerLabel.Position = [44 166 34 22];
            app.posl1SpinnerLabel.Text = 'posl1';

            % Create posl1Spinner
            app.posl1Spinner = uispinner(app.Panel);
            app.posl1Spinner.ValueChangingFcn = createCallbackFcn(app, @posl1SpinnerValueChanging, true);
            app.posl1Spinner.Limits = [28 58.5];
            app.posl1Spinner.Position = [93 166 100 22];
            app.posl1Spinner.Value = 40;

            % Create posl2SpinnerLabel
            app.posl2SpinnerLabel = uilabel(app.Panel);
            app.posl2SpinnerLabel.HorizontalAlignment = 'right';
            app.posl2SpinnerLabel.Position = [43 118 34 22];
            app.posl2SpinnerLabel.Text = 'posl2';

            % Create posl2Spinner
            app.posl2Spinner = uispinner(app.Panel);
            app.posl2Spinner.ValueChangingFcn = createCallbackFcn(app, @posl2SpinnerValueChanging, true);
            app.posl2Spinner.Limits = [68 218.5];
            app.posl2Spinner.Position = [92 118 100 22];
            app.posl2Spinner.Value = 100;

            % Create Button
            app.Button = uibutton(app.Panel, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Position = [21 14 84 22];

            % Create resetButton
            app.resetButton = uibutton(app.Panel, 'push');
            app.resetButton.ButtonPushedFcn = createCallbackFcn(app, @resetButtonPushed, true);
            app.resetButton.Position = [123 14 82 22];
            app.resetButton.Text = 'reset';

            % Create Panel2
            app.Panel2 = uipanel(app.Tab);
            app.Panel2.Title = 'Panel2';
            app.Panel2.Position = [144 24 679 73];

            % Create time1EditFieldLabel
            app.time1EditFieldLabel = uilabel(app.Panel2);
            app.time1EditFieldLabel.HorizontalAlignment = 'right';
            app.time1EditFieldLabel.Position = [68 17 35 22];
            app.time1EditFieldLabel.Text = 'time1';

            % Create time1EditField
            app.time1EditField = uieditfield(app.Panel2, 'numeric');
            app.time1EditField.Position = [118 17 100 22];

            % Create time2EditFieldLabel
            app.time2EditFieldLabel = uilabel(app.Panel2);
            app.time2EditFieldLabel.HorizontalAlignment = 'right';
            app.time2EditFieldLabel.Position = [446 17 35 22];
            app.time2EditFieldLabel.Text = 'time2';

            % Create time2EditField
            app.time2EditField = uieditfield(app.Panel2, 'numeric');
            app.time2EditField.Position = [496 17 100 22];

            % Create Tab2
            app.Tab2 = uitab(app.TabGroup);
            app.Tab2.Title = 'Tab2';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = collision

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end